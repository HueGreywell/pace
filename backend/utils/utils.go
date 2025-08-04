package utils

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/go-playground/validator/v10"
)

var Validate = validator.New()

func WriteJSON(w http.ResponseWriter, status int, v any) error {
	w.Header().Add("Content-Type", "application/json")
	w.WriteHeader(status)
	return json.NewEncoder(w).Encode(v)
}

func WriteCreated(w http.ResponseWriter, v any) {
	WriteJSON(w, http.StatusCreated, v)
}

func WriteSuccess(w http.ResponseWriter, v ...any) {
	var defaultValue any = "Success"

	if len(v) > 0 {
		defaultValue = v[0]
	}

	WriteJSON(w, http.StatusOK, defaultValue)
}

func WriteError(w http.ResponseWriter, status int, err error) {
	WriteJSON(w, status, map[string]string{"error": err.Error()})
}

func WriteBadRequest(w http.ResponseWriter, err error) {
	WriteJSON(w, http.StatusBadRequest, map[string]string{"error": err.Error()})
}

func WriteInvalidRequest(w http.ResponseWriter, err error) {
	errors := err.(validator.ValidationErrors)
	WriteError(w, http.StatusBadRequest, fmt.Errorf("invalid payload: %v", errors))
}

func ParseJSON(r *http.Request, v any) error {
	if r.Body == nil {
		return fmt.Errorf("missing request body")
	}

	return json.NewDecoder(r.Body).Decode(v)
}

func GetTokenFromRequest(r *http.Request) string {
	tokenAuth := r.Header.Get("Authorization")
	tokenQuery := r.URL.Query().Get("token")

	if tokenAuth != "" {
		return tokenAuth
	}

	if tokenQuery != "" {
		return tokenQuery
	}

	return ""
}

func GetQueryParam(r *http.Request, key string) (string, bool) {
	values := r.URL.Query()
	val := values.Get(key)

	if val == "" {
		return "", false
	}

	return val, true
}
