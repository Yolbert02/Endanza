import { db } from "../db/connection.database.js";

// ============================================
// MODELO DE ESPECIALIDADES DE DANZA
// Gestiona el catálogo de especialidades, auto-migración
// y relaciones con Secciones, Estudiantes e Inscripciones.
// ============================================

/**
 * Inicialización y auto-migración:
 * 1. Verifica/crea la tabla "Especialidad"
 * 2. Inserta los valores iniciales requeridos:
 *    - Danza Clásica
 *    - Danza Tradicional
 *    - Danza Contemporánea
 * 3. Añade la llave foránea "Id_especialidad" en Seccion, Estudiante y Estudiante_Seccion
 */
export const initTable = async () => {
  try {
    console.log("🔍 Verificando tabla de Especialidades...");

    // 1. Crear tabla Especialidad si no existe
    await db.query(`
      CREATE TABLE IF NOT EXISTS "Especialidad" (
        "Id_especialidad" SERIAL PRIMARY KEY,
        "nombre_especialidad" VARCHAR(100) NOT NULL,
        "descripcion" TEXT DEFAULT NULL,
        "area" VARCHAR(100) DEFAULT 'Danza',
        "activo" BOOLEAN DEFAULT true,
        "creado_en" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    // Asegurar restricción única en nombre_especialidad
    await db.query(`
      DO $$
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM pg_constraint WHERE conname = 'uq_especialidad_nombre'
        ) THEN
          ALTER TABLE "Especialidad" ADD CONSTRAINT uq_especialidad_nombre UNIQUE ("nombre_especialidad");
        END IF;
      EXCEPTION
        WHEN others THEN NULL;
      END $$;
    `);

    console.log("✅ Tabla Especialidad verificada/creada");

    // 2. Insertar o actualizar valores iniciales requeridos:
    // Danza Clásica, Danza Tradicional y Danza Contemporánea
    const especialidadesIniciales = [
      {
        nombre: 'Danza Clásica',
        descripcion: 'Formación académica e integral en técnica clásica, puntas, repertorio tradicional y metodología de ballet.',
        area: 'Danza'
      },
      {
        nombre: 'Danza Tradicional',
        descripcion: 'Estudio, preservación, investigación e interpretación de las danzas folklóricas y patrimoniales venezolanas y latinoamericanas.',
        area: 'Danza'
      },
      {
        nombre: 'Danza Contemporánea',
        descripcion: 'Técnicas de danza moderna y contemporánea, improvisación, composición coreográfica y expresión corporal.',
        area: 'Danza'
      }
    ];

    for (const esp of especialidadesIniciales) {
      const checkRes = await db.query(
        'SELECT "Id_especialidad" FROM "Especialidad" WHERE LOWER(TRIM("nombre_especialidad")) = LOWER(TRIM($1))',
        [esp.nombre]
      );

      if (checkRes.rows.length === 0) {
        await db.query(`
          INSERT INTO "Especialidad" ("nombre_especialidad", "descripcion", "area", "activo")
          VALUES ($1, $2, $3, true)
        `, [esp.nombre, esp.descripcion, esp.area]);
      } else {
        await db.query(`
          UPDATE "Especialidad"
          SET "activo" = true,
              "descripcion" = COALESCE("descripcion", $2),
              "area" = COALESCE("area", $3)
          WHERE "Id_especialidad" = $1
        `, [checkRes.rows[0].Id_especialidad, esp.descripcion, esp.area]);
      }
    }
    console.log("✅ Especialidades iniciales insertadas/verificadas (Clásica, Tradicional, Contemporánea)");

    // 3. Relación académica: Llaves foráneas en Seccion, Estudiante y Estudiante_Seccion
    // 3.1 Columna y FK en Seccion
    await db.query(`
      ALTER TABLE "Seccion" 
      ADD COLUMN IF NOT EXISTS "Id_especialidad" INTEGER;
    `);

    await db.query(`
      DO $$
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM pg_constraint WHERE conname = 'fk_seccion_especialidad'
        ) THEN
          ALTER TABLE "Seccion" 
          ADD CONSTRAINT fk_seccion_especialidad 
          FOREIGN KEY ("Id_especialidad") REFERENCES "Especialidad"("Id_especialidad") ON DELETE SET NULL;
        END IF;
      EXCEPTION
        WHEN duplicate_object THEN NULL;
        WHEN others THEN NULL;
      END $$;
    `);

    // 3.2 Columna y FK en Estudiante (para vincular la especialidad del estudiante en 6to, 7mo y 8vo grado)
    await db.query(`
      ALTER TABLE "Estudiante" 
      ADD COLUMN IF NOT EXISTS "Id_especialidad" INTEGER;
    `);

    await db.query(`
      DO $$
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM pg_constraint WHERE conname = 'fk_estudiante_especialidad'
        ) THEN
          ALTER TABLE "Estudiante" 
          ADD CONSTRAINT fk_estudiante_especialidad 
          FOREIGN KEY ("Id_especialidad") REFERENCES "Especialidad"("Id_especialidad") ON DELETE SET NULL;
        END IF;
      EXCEPTION
        WHEN duplicate_object THEN NULL;
        WHEN others THEN NULL;
      END $$;
    `);

    // 3.3 Columna y FK en Estudiante_Seccion (inscripción académica)
    await db.query(`
      ALTER TABLE "Estudiante_Seccion" 
      ADD COLUMN IF NOT EXISTS "Id_especialidad" INTEGER;
    `);

    await db.query(`
      DO $$
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM pg_constraint WHERE conname = 'fk_estudiante_seccion_especialidad'
        ) THEN
          ALTER TABLE "Estudiante_Seccion" 
          ADD CONSTRAINT fk_estudiante_seccion_especialidad 
          FOREIGN KEY ("Id_especialidad") REFERENCES "Especialidad"("Id_especialidad") ON DELETE SET NULL;
        END IF;
      EXCEPTION
        WHEN duplicate_object THEN NULL;
        WHEN others THEN NULL;
      END $$;
    `);

    console.log("✅ Relaciones académicas y llaves foráneas de Especialidad configuradas en Seccion, Estudiante y Estudiante_Seccion");

  } catch (error) {
    console.error("❌ Error en auto-migración de Especialidades:", error);
  }
};

// Ejecutar inicialización automáticamente al importar el modelo
initTable();

// ============================================
// MÉTODOS CRUD Y UTILIDADES
// ============================================

/**
 * Obtener todas las especialidades
 */
const findAll = async (activeOnly = true) => {
  try {
    const query = {
      text: `
        SELECT 
          "Id_especialidad" as id,
          "nombre_especialidad" as name,
          "descripcion" as description,
          "area",
          "activo" as active
        FROM "Especialidad"
        ${activeOnly ? 'WHERE "activo" = true' : ''}
        ORDER BY "Id_especialidad" ASC
      `
    };
    const { rows } = await db.query(query.text);
    return rows;
  } catch (error) {
    console.error("❌ Error en EspecialidadModel.findAll:", error);
    throw error;
  }
};

/**
 * Obtener una especialidad por ID
 */
const findById = async (id) => {
  try {
    const query = {
      text: `
        SELECT 
          "Id_especialidad" as id,
          "nombre_especialidad" as name,
          "descripcion" as description,
          "area",
          "activo" as active
        FROM "Especialidad"
        WHERE "Id_especialidad" = $1
      `,
      values: [id]
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0] || null;
  } catch (error) {
    console.error("❌ Error en EspecialidadModel.findById:", error);
    throw error;
  }
};

/**
 * Buscar especialidad por nombre o slug (búsqueda flexible e inteligente)
 */
const findByName = async (name) => {
  try {
    if (!name) return null;
    const cleanName = String(name).trim();
    const lower = cleanName.toLowerCase();

    // Detección por palabras clave o slug (ej. ballet_clasico, danza_tradicional, etc.)
    let keywordPattern = null;
    if (lower.includes('clasic') || lower.includes('ballet')) {
      keywordPattern = '%cl_sica%';
    } else if (lower.includes('contempor')) {
      keywordPattern = '%contempor_nea%';
    } else if (lower.includes('tradicion') || lower.includes('folk')) {
      keywordPattern = '%tradicional%';
    }

    const query = {
      text: `
        SELECT 
          "Id_especialidad" as id,
          "Id_especialidad" as especialidad_id,
          "nombre_especialidad" as name,
          "nombre_especialidad" as especialidad,
          "descripcion" as description,
          "area",
          "activo" as active
        FROM "Especialidad"
        WHERE LOWER("nombre_especialidad") = LOWER($1)
           OR LOWER("nombre_especialidad") LIKE LOWER($2)
           OR ($3::TEXT IS NOT NULL AND "nombre_especialidad" ILIKE $3)
        LIMIT 1
      `,
      values: [cleanName, `%${cleanName}%`, keywordPattern]
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0] || null;
  } catch (error) {
    console.error("❌ Error en EspecialidadModel.findByName:", error);
    throw error;
  }
};

/**
 * Determinar si un grado o nivel académico requiere especialidad (6to, 7mo u 8vo)
 */
const isSpecialtyRequired = (gradeName) => {
  if (!gradeName) return false;
  const normalized = String(gradeName).toLowerCase().trim();
  return (
    normalized.includes('6to') ||
    normalized.includes('sexto') ||
    normalized.includes('7mo') ||
    normalized.includes('séptimo') ||
    normalized.includes('septimo') ||
    normalized.includes('8vo') ||
    normalized.includes('octavo')
  );
};

/**
 * Crear nueva especialidad
 */
const create = async (data) => {
  try {
    const { nombre_especialidad, descripcion, area = 'Danza' } = data;
    const query = {
      text: `
        INSERT INTO "Especialidad" ("nombre_especialidad", "descripcion", "area", "activo")
        VALUES ($1, $2, $3, true)
        RETURNING 
          "Id_especialidad" as id,
          "nombre_especialidad" as name,
          "descripcion" as description,
          "area",
          "activo" as active
      `,
      values: [nombre_especialidad, descripcion, area]
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0];
  } catch (error) {
    console.error("❌ Error en EspecialidadModel.create:", error);
    throw error;
  }
};

/**
 * Actualizar especialidad
 */
const update = async (id, data) => {
  try {
    const { nombre_especialidad, descripcion, area, activo } = data;
    const query = {
      text: `
        UPDATE "Especialidad"
        SET 
          "nombre_especialidad" = COALESCE($1, "nombre_especialidad"),
          "descripcion" = COALESCE($2, "descripcion"),
          "area" = COALESCE($3, "area"),
          "activo" = COALESCE($4, "activo")
        WHERE "Id_especialidad" = $5
        RETURNING 
          "Id_especialidad" as id,
          "nombre_especialidad" as name,
          "descripcion" as description,
          "area",
          "activo" as active
      `,
      values: [nombre_especialidad, descripcion, area, activo, id]
    };
    const { rows } = await db.query(query.text, query.values);
    return rows[0] || null;
  } catch (error) {
    console.error("❌ Error en EspecialidadModel.update:", error);
    throw error;
  }
};

export const EspecialidadModel = {
  initTable,
  findAll,
  findById,
  findByName,
  isSpecialtyRequired,
  create,
  update
};

export default EspecialidadModel;
