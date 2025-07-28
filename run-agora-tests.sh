#!/bin/bash

# Script para ejecutar específicamente las pruebas de agora
# Uso: ./run-agora-tests.sh

echo "🧪 Ejecutando pruebas de Agora..."
echo "================================"

# Configurar el entorno para pruebas
export DJANGO_SETTINGS_MODULE=agora_site.test_settings

# Ejecutar las pruebas específicas de agora
python manage.py test agora_site.agora_core.tests.agora --verbosity=2

# Verificar el resultado
if [ $? -eq 0 ]; then
    echo "✅ ¡Todas las pruebas de agora pasaron exitosamente!"
    exit 0
else
    echo "❌ Algunas pruebas fallaron."
    exit 1
fi 