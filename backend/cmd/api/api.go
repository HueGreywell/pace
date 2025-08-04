package api

import (
	"database/sql"
	"log"
	"net/http"
	"pace/services/user"

	_ "pace/docs"

	"github.com/gorilla/mux"
	httpSwagger "github.com/swaggo/http-swagger"
)

type APIServer struct {
	addr string
	db   *sql.DB
}

func NewAPIServer(addr string, db *sql.DB) *APIServer {
	return &APIServer{
		addr: addr,
		db:   db,
	}
}

func (s *APIServer) Run() error {
	router := mux.NewRouter()
	subrouter := router.PathPrefix("/api/v1").Subrouter()

	userStore := user.NewStore(s.db)
	userHandler := user.NewHandler(userStore)
	userHandler.RegisterRoutes(subrouter)

	log.Println("Listening on", s.addr)
	log.Println("http://localhost:8080/swagger/index.html")
	router.PathPrefix("/swagger/").Handler(httpSwagger.WrapHandler)

	return http.ListenAndServe(s.addr, router)
}
