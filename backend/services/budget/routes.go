package budget

/*
type Handler struct {
	store     models.BudgetStore
	userStore models.UserStore
}

func NewHandler(store models.BudgetStore, userStore models.UserStore) *Handler {
	return &Handler{store: store, userStore: userStore}
}

func (h *Handler) RegisterRoutes(router *mux.Router) {
	router.HandleFunc("/budget", auth.WithJWTAuth(h.createBudget, h.userStore)).Methods(http.MethodPost)
	router.HandleFunc("/budgets", auth.WithJWTAuth(h.handleGetBudgets, h.userStore)).Methods(http.MethodGet)
}

func (h *Handler) createBudget(w http.ResponseWriter, r *http.Request) {
	var budget models.CreateBudgetPayload

	if err := utils.ParseJSON(r, &budget); err != nil {
		utils.WriteError(w, http.StatusBadRequest, err)
		return
	}

	if err := utils.Validate.Struct(budget); err != nil {
		errors := err.(validator.ValidationErrors)
		utils.WriteError(w, http.StatusBadRequest, fmt.Errorf("invalid payload: %v", errors))
		return
	}

	userID := auth.GetUserIDFromContext(r.Context())
	err := h.store.CreateBudget(budget, userID)

	if err != nil {
		fmt.Print(err)
		utils.WriteError(w, http.StatusInternalServerError, err)
		return
	}

	utils.WriteJSON(w, http.StatusOK, nil)
}

func (h *Handler) handleGetBudgets(w http.ResponseWriter, r *http.Request) {
	userID := auth.GetUserIDFromContext(r.Context())
	budgets, err := h.store.GetBudgets(userID)

	if err != nil {
		fmt.Print(err)
		utils.WriteError(w, http.StatusInternalServerError, err)
		return
	}

	utils.WriteJSON(w, http.StatusOK, budgets)
}
*/
