package models

import (
	"time"
)

type CreateHabitLog struct {
	Id          int       `json:"id"`
	CompletedAt time.Time `json:"completedAt"`
}

type HabitLog struct {
	ID          int       `json:"id"`
	HabitID     int       `json:"habitId"`
	CompletedAt time.Time `json:"completedAt"`
}

type HabitLogStore interface {
	CreateHabitLog(habit *CreateHabitLog, userID int, habitID int) (*HabitLog, error)
	DeleteHabitLog(habitID int, userID int) error
	GetHabitLogs(userID int) ([]HabitLog, error)
}

type CreateHabit struct {
	Name string `json:"name" binding:"required"`
}

type Habit struct {
	ID      int        `json:"id" binding:"required"`
	Name    string     `json:"name" binding:"required"`
	Entries []HabitLog `json:"entries" binding:"required"`
}

type HabitStore interface {
	DeleteHabit(habitID int, userID int) error
	CreateHabit(habit *CreateHabit, userID int) (*Habit, error)
	GetHabits(userID int) ([]Habit, error)
}
