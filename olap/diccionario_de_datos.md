# Diccionario de Datos

Este documento contiene los diccionarios de datos para la base de datos transaccional (OLTP) de ventas y el Data Warehouse (OLAP).

## 1. Base de Datos Transaccional (OLTP) - Esquema `hans`

### Tipos de Datos Personalizados (ENUM)
* **`payment_method`**: Define los métodos de pago aceptados. Valores: `'CARD'`, `'CASH'`.

### Tablas

#### 1.1 `countries` (Países)
| Columna | Tipo de Dato | Restricciones | Descripción |
| :--- | :--- | :--- | :--- |
| `country_id` | SERIAL | PRIMARY KEY | Identificador único del país. |
| `key` | VARCHAR(10) | NOT NULL, UNIQUE | Código o clave del país (ej. MX, US). |
| `name` | VARCHAR(100) | NOT NULL, UNIQUE | Nombre del país. |

#### 1.2 `states` (Estados/Provincias)
| Columna | Tipo de Dato | Restricciones | Descripción |
| :--- | :--- | :--- | :--- |
| `state_id` | SERIAL | PRIMARY KEY | Identificador único del estado. |
| `key` | VARCHAR(10) | NOT NULL, UNIQUE | Código o clave del estado. |
| `name` | VARCHAR(100) | NOT NULL | Nombre del estado. |
| `country_id` | INT | NOT NULL, FK(`countries`), ON DELETE CASCADE | Identificador del país al que pertenece el estado. |

#### 1.3 `branches` (Sucursales)
| Columna | Tipo de Dato | Restricciones | Descripción |
| :--- | :--- | :--- | :--- |
| `branch_id` | SERIAL | PRIMARY KEY | Identificador único de la sucursal. |
| `state_id` | INT | NOT NULL, FK(`states`), ON DELETE RESTRICT | Identificador del estado donde se ubica la sucursal. |
| `name` | VARCHAR(100) | NOT NULL | Nombre de la sucursal. |
| `address` | TEXT | NOT NULL | Dirección completa de la sucursal. |

#### 1.4 `categories` (Categorías de Productos)
| Columna | Tipo de Dato | Restricciones | Descripción |
| :--- | :--- | :--- | :--- |
| `category_id` | SERIAL | PRIMARY KEY | Identificador único de la categoría. |
| `name` | VARCHAR(100) | NOT NULL, UNIQUE | Nombre de la categoría. |
| `description` | TEXT | | Descripción detallada de la categoría. |

#### 1.5 `products` (Productos)
| Columna | Tipo de Dato | Restricciones | Descripción |
| :--- | :--- | :--- | :--- |
| `product_id` | SERIAL | PRIMARY KEY | Identificador único del producto. |
| `category_id` | INT | NOT NULL, FK(`categories`), ON DELETE RESTRICT | Identificador de la categoría del producto. |
| `sku` | VARCHAR(50) | NOT NULL, UNIQUE | Código SKU (Stock Keeping Unit) del producto. |
| `barcode` | VARCHAR(50) | UNIQUE | Código de barras del producto. |
| `name` | VARCHAR(200) | NOT NULL | Nombre o descripción del producto. |
| `base_price` | NUMERIC(10, 2)| NOT NULL | Precio base de venta del producto. |

#### 1.6 `sales` (Ventas - Encabezado)
| Columna | Tipo de Dato | Restricciones | Descripción |
| :--- | :--- | :--- | :--- |
| `sale_id` | SERIAL | PRIMARY KEY | Identificador único de la venta. |
| `branch_id` | INT | NOT NULL, FK(`branches`), ON DELETE RESTRICT | Sucursal donde se realizó la venta. |
| `sale_date` | TIMESTAMP WITH TIME ZONE | DEFAULT CURRENT_TIMESTAMP | Fecha y hora de la venta. |
| `total_amount`| NUMERIC(12, 2)| NOT NULL | Monto total de la venta. |
| `method` | payment_method| NOT NULL | Método de pago utilizado (`CARD` o `CASH`). |
| `ticket_number`| VARCHAR(100) | UNIQUE | Número de ticket o recibo de la venta. |

#### 1.7 `sale_details` (Detalles de Venta)
| Columna | Tipo de Dato | Restricciones | Descripción |
| :--- | :--- | :--- | :--- |
| `sale_id` | INT | PK, FK(`sales`), ON DELETE CASCADE | Identificador de la venta asociada. |
| `product_id` | INT | PK, FK(`products`), ON DELETE RESTRICT | Identificador del producto vendido. |
| `quantity` | NUMERIC(8, 3) | NOT NULL, CHECK > 0 | Cantidad de unidades vendidas. |
| `unit_price` | NUMERIC(10, 2)| NOT NULL, CHECK >= 0 | Precio unitario al momento de la venta. |
| `subtotal` | NUMERIC(12, 2)| NOT NULL, CHECK >= 0 | Subtotal de la línea (cantidad * unit_price). |

---

## 2. Data Warehouse (OLAP) - Esquema de Estrella

### Dimensiones

#### 2.1 `dim_date` (Dimensión de Fecha)
| Columna | Tipo de Dato | Restricciones | Descripción |
| :--- | :--- | :--- | :--- |
| `date_key` | INT | PRIMARY KEY | Llave subrogada (Formato YYYYMMDD). |
| `full_date` | DATE | NOT NULL | Fecha completa. |
| `year` | INT | NOT NULL | Año de la fecha. |
| `quarter` | INT | NOT NULL | Trimestre del año (1-4). |
| `month` | INT | NOT NULL | Mes del año (1-12). |
| `month_name` | VARCHAR(20) | NOT NULL | Nombre del mes. |
| `day` | INT | NOT NULL | Día del mes (1-31). |
| `day_of_week` | VARCHAR(20) | NOT NULL | Nombre del día de la semana. |
| `is_weekend` | BOOLEAN | NOT NULL | Indicador de fin de semana (Verdadero/Falso). |

#### 2.2 `dim_time` (Dimensión de Tiempo)
| Columna | Tipo de Dato | Restricciones | Descripción |
| :--- | :--- | :--- | :--- |
| `time_key` | INT | PRIMARY KEY | Llave subrogada (Formato HHMMSS). |
| `hour` | INT | NOT NULL | Hora del día (0-23). |
| `minute` | INT | NOT NULL | Minuto de la hora (0-59). |
| `second` | INT | NOT NULL | Segundo del minuto (0-59). |
| `time_of_day` | VARCHAR(20) | NOT NULL | Clasificación del momento del día (ej. Mañana, Tarde). |

#### 2.3 `dim_branch` (Dimensión de Sucursal)
| Columna | Tipo de Dato | Restricciones | Descripción |
| :--- | :--- | :--- | :--- |
| `branch_key` | SERIAL | PRIMARY KEY | Llave subrogada de la sucursal en el DW. |
| `branch_id` | INT | NOT NULL | Identificador original de la sucursal (Sistema OLTP). |
| `branch_name` | VARCHAR(100) | NOT NULL | Nombre de la sucursal. |
| `address` | TEXT | NOT NULL | Dirección completa de la sucursal. |
| `state_code` | VARCHAR(10) | NOT NULL | Código del estado. |
| `state_name` | VARCHAR(100) | NOT NULL | Nombre del estado. |
| `country_code`| VARCHAR(10) | NOT NULL | Código del país. |
| `country_name`| VARCHAR(100) | NOT NULL | Nombre del país. |

#### 2.4 `dim_product` (Dimensión de Producto)
| Columna | Tipo de Dato | Restricciones | Descripción |
| :--- | :--- | :--- | :--- |
| `product_key` | SERIAL | PRIMARY KEY | Llave subrogada del producto en el DW. |
| `product_id` | INT | NOT NULL | Identificador original del producto (Sistema OLTP). |
| `sku` | VARCHAR(50) | NOT NULL | Código SKU del producto. |
| `barcode` | VARCHAR(50) | | Código de barras del producto. |
| `product_name`| VARCHAR(200) | NOT NULL | Nombre o descripción del producto. |
| `current_base_price`| NUMERIC(10, 2)| NOT NULL | Precio base actual del producto. |
| `category_name`| VARCHAR(100) | NOT NULL | Nombre de la categoría a la que pertenece. |
| `category_description`| TEXT | | Descripción de la categoría. |

#### 2.5 `dim_payment_method` (Dimensión de Método de Pago)
| Columna | Tipo de Dato | Restricciones | Descripción |
| :--- | :--- | :--- | :--- |
| `payment_method_key`| SERIAL | PRIMARY KEY | Llave subrogada del método de pago. |
| `method_name` | VARCHAR(50) | NOT NULL | Nombre del método de pago. |

### Tabla de Hechos

#### 2.6 `fact_sales` (Hechos de Ventas)
| Columna | Tipo de Dato | Restricciones | Descripción |
| :--- | :--- | :--- | :--- |
| `date_key` | INT | PK, FK(`dim_date`) | Referencia a la dimensión de fecha. |
| `time_key` | INT | PK, FK(`dim_time`) | Referencia a la dimensión de tiempo. |
| `branch_key` | INT | PK, FK(`dim_branch`) | Referencia a la dimensión de sucursal. |
| `product_key` | INT | PK, FK(`dim_product`) | Referencia a la dimensión de producto. |
| `payment_method_key`| INT | PK, FK(`dim_payment_method`)| Referencia a la dimensión de método de pago. |
| `sale_id` | INT | NOT NULL | Identificador de la venta original (OLTP). |
| `ticket_number`| VARCHAR(100) | | Número de ticket de la venta. |
| `quantity` | NUMERIC(8, 3) | NOT NULL | Cantidad de unidades vendidas. |
| `unit_price` | NUMERIC(10, 2)| NOT NULL | Precio unitario al momento de la venta. |
| `base_price_at_sale`| NUMERIC(10, 2)| NOT NULL | Precio base del producto al momento de la venta. |
| `subtotal` | NUMERIC(12, 2)| NOT NULL | Subtotal pagado por esta línea de detalle. |
| `discount_amount`| NUMERIC(12, 2)| NOT NULL | Monto de descuento aplicado. |
