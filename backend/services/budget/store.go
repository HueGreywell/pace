package budget

import (
	"database/sql"
	"fmt"
	"pace/models"
	"strings"
)

type Store struct {
	db *sql.DB
}

func NewStore(db *sql.DB) *Store {
	return &Store{db: db}
}

func (s *Store) CreateBudget(budget models.CreateBudgetPayload, userID int) error {

	result, err := s.db.Exec(
		"INSERT INTO budgets (name, amount) VALUES (?, ?)",
		budget.Name, budget.Amount,
	)

	if err != nil {
		return err
	}

	budgetID, err := result.LastInsertId()

	if err != nil {
		return err
	}

	_, err = s.db.Exec(
		"INSERT INTO budget_users (budgetId, userId) VALUES (?, ?)",
		budgetID, userID,
	)

	if err != nil {
		return err
	}

	return nil
}

func (s *Store) GetBudgets(userID int) ([]models.Budget, error) {
	userBudgetIds, err := findUserBudgets(s, userID)

	if err != nil {
		return nil, err
	}

	placeholders := make([]string, len(userBudgetIds))
	args := make([]interface{}, len(userBudgetIds))

	for i, id := range userBudgetIds {
		placeholders[i] = "?"
		args[i] = id
	}

	query := fmt.Sprintf("SELECT * FROM budgets WHERE id IN (%s)", strings.Join(placeholders, ","))

	rows, err := s.db.Query(query, args...)

	if err != nil {
		return nil, err
	}

	defer rows.Close()

	budgets, err := scanRowsIntoBudget(rows)

	if err != nil {
		return nil, err
	}

	return budgets, nil

}

func findUserBudgets(s *Store, userID int) ([]int, error) {
	rows, err := s.db.Query("SELECT * FROM budget_users WHERE userID= ?", userID)

	if err != nil {
		return nil, err
	}

	budgetIds := []int{}

	for rows.Next() {
		budgetUser := new(models.BudgetUser)

		err := rows.Scan(
			&budgetUser.BudgetID,
			&budgetUser.UserID,
		)

		if err != nil {
			return nil, err
		}

		budgetIds = append(budgetIds, budgetUser.BudgetID)

	}

	return budgetIds, nil

}

func scanRowsIntoBudget(rows *sql.Rows) ([]models.Budget, error) {
	var budgets []models.Budget

	for rows.Next() {
		budget := new(models.Budget)

		err := rows.Scan(
			&budget.ID,
			&budget.Name,
			&budget.Amount,
			&budget.CreatedAt,
		)

		if err != nil {
			return nil, err
		}

		budgets = append(budgets, *budget)

	}

	return budgets, nil
}
