# Sales OLTP -> OLAP ETL — developer tasks
VENV := .venv
PY   := $(VENV)/bin/python
PIP  := $(VENV)/bin/pip

.DEFAULT_GOAL := help
.PHONY: help setup run run-fresh validate test clean

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

setup: ## Create venv, install deps, scaffold .env
	python3 -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	@test -f .env || cp .env.example .env
	@echo "Setup complete. Edit etl/.env if your DB credentials differ."

run: ## Run the full-refresh ETL (assumes the DW schema already exists)
	$(PY) run_etl.py

run-fresh: ## Apply olap/dw DDL (idempotent) then run the ETL
	$(PY) run_etl.py --init-schema

validate: ## Run data-quality checks against the current warehouse
	$(PY) run_etl.py --validate-only

test: ## Run unit tests (transform layer)
	$(PY) -m pytest -q

clean: ## Remove venv and caches
	rm -rf $(VENV) .pytest_cache
	find . -type d -name __pycache__ -prune -exec rm -rf {} +
