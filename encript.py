from base64 import b64decode
import binascii

# Reemplaza con tus claves generadas
key_base64 = 'cgwrWJfWRo9txAMUTC8vy2HN5X2JnDqcUZ/jX78sZgN8='
iv_base64 = 'fET0d+RfL5NWuzIODfpNRQ=='

# Decodificar de base64 a bytes
key_bytes = b64decode(key_base64)
iv_bytes = b64decode(iv_base64)

# Convertir a hexadecimal
key_hex = binascii.hexlify(key_bytes).decode('utf-8')
iv_hex = binascii.hexlify(iv_bytes).decode('utf-8')

print(f"Key (hex): {key_hex}")
print(f"IV (hex): {iv_hex}")
