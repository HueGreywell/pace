package models

type PaginatedPayload[T any] struct {
	Items []T            `json:"items" `
	Meta  PaginationMeta `json:"meta"`
}

type PaginationMeta struct {
	Page       int `json:"page"`
	PerPage    int `json:"perPage"`
	TotalItems int `json:"totalItems"`
	TotalPages int `json:"totalPages"`
}

func NewPaginationMeta(page, perPage, totalItems int) PaginationMeta {
	totalPages := (totalItems + perPage - 1) / perPage
	return PaginationMeta{
		Page:       page,
		PerPage:    perPage,
		TotalItems: totalItems,
		TotalPages: totalPages,
	}
}

func (p PaginationMeta) Offset() int {
	return (p.Page - 1) * p.PerPage
}
