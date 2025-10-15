#!/usr/bin/env bash
set -e

echo "🔍 Установка линтеров..."
pip install -q flake8 pylint autopep8

echo "🧹 Проверка flake8..."
flake8 . \
  --exclude=env,.venv,venv,__pycache__ \
  || echo "⚠️ flake8: найдены замечания"

echo "🧠 Проверка pylint..."
find . -name "*.py" \
  -not -path "./env/*" \
  -not -path "./.venv/*" \
  -not -path "./venv/*" \
  -not -path "*/__pycache__/*" \
  | xargs pylint || echo "⚠️ pylint: найдены замечания"

echo "🪄 Автоматическое исправление autopep8..."
find . -name "*.py" \
  -not -path "./env/*" \
  -not -path "./.venv/*" \
  -not -path "./venv/*" \
  -not -path "*/__pycache__/*" \
  | xargs autopep8 --in-place --aggressive --aggressive

echo "✅ Повторная проверка после форматирования..."
flake8 . --exclude=env,.venv,venv,__pycache__ \
  || echo "⚠️ После autopep8 остались замечания"

echo "✨ Проверка завершена!"
