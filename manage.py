#!/usr/bin/env python
import os, sys
# --- PATCH para evitar error _uuid_generate_random en Python 2.7 en Docker ---
import uuid
import os
if not hasattr(uuid, '_uuid_generate_random'):
    uuid._uuid_generate_random = lambda: os.urandom(16)


if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "agora_site.settings")

    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)
