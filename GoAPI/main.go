package main

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

type Response struct {
	Message string `json:"message"`
}

func main() {
	router := mux.NewRouter()
	router.HandleFunc("/api", func (w http.ResponseWriter, r *http.Request)  {
		response := Response{Message: "Hello, World!"}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)
	}).Methods("GET")

	fmt.Println("Starting server on :8080")
	http.ListenAndServe(":8080", router)
	
	router.HandleFunc("/api/greet/{name}", func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		name := vars["name"]
		response := Response{Message: "Hola: " + name}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(response)
	}).Methods("GET")
}