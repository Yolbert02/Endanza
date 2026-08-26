// Archivo: backend/src/scripts/seed_malla_endanza.js
import { db } from "../db/connection.database.js";

async function seedMallaEndanza() {
  const client = await db.pool.connect();
  try {
    console.log("🚀 Iniciando población de la Malla Curricular ENDANZA...");
    await client.query("BEGIN");

    // 1. Asegurar columnas y ampliar límites de caracteres si es necesario
    await client.query(`
      ALTER TABLE "Grado" ALTER COLUMN "nombre_grado" TYPE VARCHAR(100);
      ALTER TABLE "Grado" ALTER COLUMN "nivel" TYPE VARCHAR(100);
      ALTER TABLE "Nivel_Danza" ALTER COLUMN "nivel_danza" TYPE VARCHAR(100);
      ALTER TABLE "Materia" ALTER COLUMN "nombre_materia" TYPE VARCHAR(150);
      ALTER TABLE "Materia" ALTER COLUMN "tipo_materia" TYPE VARCHAR(50);
      ALTER TABLE "Materia" ADD COLUMN IF NOT EXISTS "horas_semanales" INTEGER DEFAULT 0;
      ALTER TABLE "Materia" ADD COLUMN IF NOT EXISTS "observaciones" TEXT DEFAULT NULL;
    `);

    // 2. Poblar Especialidades
    console.log("📌 Registrando Especialidades...");
    const especialidades = [
      { nombre: "Danza Clásica", area: "Clásica", descripcion: "Formación especializada en técnica clásica académica y repertorio." },
      { nombre: "Danza Tradicional", area: "Tradicional", descripcion: "Formación especializada en bailes tradicionales venezolanos, latinoamericanos y cultura popular." },
      { nombre: "Danza Contemporánea", area: "Contemporánea", descripcion: "Formación especializada en técnicas contemporáneas, expresión corporal y composición." }
    ];

    for (const esp of especialidades) {
      await client.query(`
        INSERT INTO "Especialidad" ("nombre_especialidad", "area", "descripcion", "activo")
        VALUES ($1, $2, $3, true)
        ON CONFLICT DO NOTHING
      `, [esp.nombre, esp.area, esp.descripcion]);
    }

    // 3. Poblar Grados y Niveles de Danza
    console.log("📌 Registrando Grados y Niveles de Danza...");
    const gradosData = [
      // Estudios Iniciales
      { nombre: "Preparatorio", nivel: "Estudios Iniciales", desc: "Iniciación para niños de 7 y 8 años" },

      // Componente General (1º a 4º Año)
      { nombre: "1er Año", nivel: "Componente General", desc: "1er año del componente general de danza" },
      { nombre: "2do Año", nivel: "Componente General", desc: "2do año del componente general de danza" },
      { nombre: "3er Año", nivel: "Componente General", desc: "3er año del componente general de danza" },
      { nombre: "4to Año", nivel: "Componente General", desc: "4to año del componente general de danza" },

      // Componente Especializado: Danza Clásica
      { nombre: "5to Año - Danza Clásica", nivel: "Componente Especializado", desc: "5to año especialidad Danza Clásica" },
      { nombre: "6to Año - Danza Clásica", nivel: "Componente Especializado", desc: "6to año especialidad Danza Clásica" },
      { nombre: "7mo Año - Danza Clásica", nivel: "Componente Especializado", desc: "7mo año especialidad Danza Clásica" },
      { nombre: "8vo Año - Danza Clásica", nivel: "Componente Especializado", desc: "8vo año especialidad Danza Clásica" },

      // Componente Especializado: Danza Tradicional
      { nombre: "5to Año - Danza Tradicional", nivel: "Componente Especializado", desc: "5to año especialidad Danza Tradicional" },
      { nombre: "6to Año - Danza Tradicional", nivel: "Componente Especializado", desc: "6to año especialidad Danza Tradicional" },
      { nombre: "7mo Año - Danza Tradicional", nivel: "Componente Especializado", desc: "7mo año especialidad Danza Tradicional" },
      { nombre: "8vo Año - Danza Tradicional", nivel: "Componente Especializado", desc: "8vo año especialidad Danza Tradicional" },

      // Componente Especializado: Danza Contemporánea
      { nombre: "5to Año - Danza Contemporánea", nivel: "Componente Especializado", desc: "5to año especialidad Danza Contemporánea" },
      { nombre: "6to Año - Danza Contemporánea", nivel: "Componente Especializado", desc: "6to año especialidad Danza Contemporánea" },
      { nombre: "7mo Año - Danza Contemporánea", nivel: "Componente Especializado", desc: "7mo año especialidad Danza Contemporánea" },
      { nombre: "8vo Año - Danza Contemporánea", nivel: "Componente Especializado", desc: "8vo año especialidad Danza Contemporánea" }
    ];

    const gradoMap = {}; // nombre_grado -> Id_grado

    for (const g of gradosData) {
      // Insertar en Grado
      let resGrado = await client.query(`
        SELECT "Id_grado" FROM "Grado" WHERE "nombre_grado" = $1
      `, [g.nombre]);

      let gradoId;
      if (resGrado.rows.length === 0) {
        const insertG = await client.query(`
          INSERT INTO "Grado" ("nombre_grado", "nivel", "descripcion", "activo")
          VALUES ($1, $2, $3, true)
          RETURNING "Id_grado"
        `, [g.nombre, g.nivel, g.desc]);
        gradoId = insertG.rows[0].Id_grado;
      } else {
        gradoId = resGrado.rows[0].Id_grado;
      }
      gradoMap[g.nombre] = gradoId;

      // Insertar en Nivel_Danza si no existe
      const existNivel = await client.query(`
        SELECT "Id_nivel_danza" FROM "Nivel_Danza" WHERE "nivel_danza" = $1
      `, [g.nombre]);

      if (existNivel.rows.length === 0) {
        await client.query(`
          INSERT INTO "Nivel_Danza" ("nivel_danza")
          VALUES ($1)
        `, [g.nombre]);
      }
    }

    // 4. Malla Curricular de Materias
    console.log("📌 Registrando Materias oficiales (Prácticas y Teóricas)...");

    const mallaCurricular = [
      // ==========================================
      // PREPARATORIO
      // ==========================================
      { grado: "Preparatorio", nombre: "Iniciación a la Danza", horas: 2, tipo: "practica", obs: "A través de la plástica, la música y juegos" },
      { grado: "Preparatorio", nombre: "Danza Tradicional", horas: 1, tipo: "practica", obs: "Bailes y juegos tradicionales" },
      { grado: "Preparatorio", nombre: "Preparación Física", horas: 1, tipo: "practica", obs: "Desarrollo de condiciones físicas iniciales" },
      { grado: "Preparatorio", nombre: "Música", horas: 1, tipo: "teorica", obs: "Impartida de manera teórica y práctica (lúdica)" },

      // ==========================================
      // PRIMER AÑO
      // ==========================================
      { grado: "1er Año", nombre: "Danza Clásica", horas: 6, tipo: "practica", obs: null },
      { grado: "1er Año", nombre: "Danza Tradicional", horas: 4, tipo: "practica", obs: null },
      { grado: "1er Año", nombre: "Danza Creativa", horas: 2, tipo: "practica", obs: "Enfocada a fortalecer la asignatura Danza Contemporánea" },
      { grado: "1er Año", nombre: "Música", horas: 1, tipo: "teorica", obs: null },
      { grado: "1er Año", nombre: "Preparación Física", horas: 1, tipo: "practica", obs: "Con asesoría nutricional" },
      { grado: "1er Año", nombre: "Francés 1", horas: 1, tipo: "teorica", obs: "Código universal dentro de la danza clásica" },

      // ==========================================
      // SEGUNDO AÑO
      // ==========================================
      { grado: "2do Año", nombre: "Danza Clásica", horas: 6, tipo: "practica", obs: null },
      { grado: "2do Año", nombre: "Danza Tradicional", horas: 4, tipo: "practica", obs: null },
      { grado: "2do Año", nombre: "Danza Creativa", horas: 2, tipo: "practica", obs: "Enfocada a fortalecer Danza Contemporánea" },
      { grado: "2do Año", nombre: "Música", horas: 2, tipo: "teorica", obs: "Hora de 60 minutos" },
      { grado: "2do Año", nombre: "Preparación Física", horas: 2, tipo: "practica", obs: null },
      { grado: "2do Año", nombre: "Historia de la Danza", horas: 1, tipo: "teorica", obs: "Seminario durante el año escolar" },
      { grado: "2do Año", nombre: "Francés 2", horas: 1, tipo: "teorica", obs: "Taller al final de cada trimestre" },
      { grado: "2do Año", nombre: "Nutrición", horas: 1, tipo: "teorica", obs: "Taller al final de cada trimestre" },

      // ==========================================
      // TERCER AÑO
      // ==========================================
      { grado: "3er Año", nombre: "Danza Clásica", horas: 6, tipo: "practica", obs: null },
      { grado: "3er Año", nombre: "Danza Tradicional", horas: 6, tipo: "practica", obs: null },
      { grado: "3er Año", nombre: "Danza Contemporánea", horas: 4, tipo: "practica", obs: null },
      { grado: "3er Año", nombre: "Música", horas: 2, tipo: "teorica", obs: null },
      { grado: "3er Año", nombre: "Preparación Física", horas: 1, tipo: "practica", obs: null },
      { grado: "3er Año", nombre: "Historia de la Danza", horas: 1, tipo: "teorica", obs: "Seminario durante el año escolar" },
      { grado: "3er Año", nombre: "Francés", horas: 1, tipo: "teorica", obs: "Taller al final de cada trimestre" },
      { grado: "3er Año", nombre: "Nutrición", horas: 1, tipo: "teorica", obs: "Taller al final de cada trimestre" },

      // ==========================================
      // CUARTO AÑO
      // ==========================================
      { grado: "4to Año", nombre: "Danza Clásica", horas: 6, tipo: "practica", obs: null },
      { grado: "4to Año", nombre: "Danza Tradicional", horas: 6, tipo: "practica", obs: null },
      { grado: "4to Año", nombre: "Danza Contemporánea", horas: 6, tipo: "practica", obs: null },
      { grado: "4to Año", nombre: "Música", horas: 1, tipo: "teorica", obs: null },
      { grado: "4to Año", nombre: "Preparación Física", horas: 1, tipo: "practica", obs: null },
      { grado: "4to Año", nombre: "Repertorio Clásico", horas: 1, tipo: "teorico-practica", obs: "Teórico-práctica" },
      { grado: "4to Año", nombre: "Repertorio Tradicional", horas: 1, tipo: "teorico-practica", obs: "Teórico-práctica" },
      { grado: "4to Año", nombre: "Repertorio Contemporáneo", horas: 1, tipo: "teorico-practica", obs: "Teórico-práctica" },

      // ==========================================
      // ESPECIALIDAD: DANZA CLÁSICA (5º a 8º Año)
      // ==========================================
      // 5to Año - Clásica
      { grado: "5to Año - Danza Clásica", nombre: "Danza Clásica", horas: 10, tipo: "practica", obs: null },
      { grado: "5to Año - Danza Clásica", nombre: "Danza Tradicional", horas: 2, tipo: "practica", obs: null },
      { grado: "5to Año - Danza Clásica", nombre: "Danza Contemporánea", horas: 4, tipo: "practica", obs: null },
      { grado: "5to Año - Danza Clásica", nombre: "Historia de la Danza", horas: 1, tipo: "teorica", obs: "Enfocada a la especialidad" },
      { grado: "5to Año - Danza Clásica", nombre: "Repertorio", horas: 2, tipo: "practica", obs: null },
      { grado: "5to Año - Danza Clásica", nombre: "Composición Coreográfica", horas: 2, tipo: "practica", obs: null },
      { grado: "5to Año - Danza Clásica", nombre: "Kinesiología", horas: 1, tipo: "teorica", obs: null },

      // 6to Año - Clásica
      { grado: "6to Año - Danza Clásica", nombre: "Danza Clásica", horas: 10, tipo: "practica", obs: null },
      { grado: "6to Año - Danza Clásica", nombre: "Danza Tradicional", horas: 2, tipo: "practica", obs: null },
      { grado: "6to Año - Danza Clásica", nombre: "Danza Contemporánea", horas: 2, tipo: "practica", obs: null },
      { grado: "6to Año - Danza Clásica", nombre: "Historia de la Danza", horas: 1, tipo: "teorica", obs: null },
      { grado: "6to Año - Danza Clásica", nombre: "Repertorio", horas: 2, tipo: "practica", obs: null },
      { grado: "6to Año - Danza Clásica", nombre: "Composición Coreográfica", horas: 2, tipo: "practica", obs: null },
      { grado: "6to Año - Danza Clásica", nombre: "Pas de deux", horas: 2, tipo: "practica", obs: null },
      { grado: "6to Año - Danza Clásica", nombre: "Danzas de Carácter", horas: 1, tipo: "practica", obs: null },

      // 7mo Año - Clásica
      { grado: "7mo Año - Danza Clásica", nombre: "Danza Clásica", horas: 10, tipo: "practica", obs: null },
      { grado: "7mo Año - Danza Clásica", nombre: "Danza Tradicional", horas: 2, tipo: "practica", obs: null },
      { grado: "7mo Año - Danza Clásica", nombre: "Danza Contemporánea", horas: 2, tipo: "practica", obs: null },
      { grado: "7mo Año - Danza Clásica", nombre: "Repertorio", horas: 4, tipo: "practica", obs: null },
      { grado: "7mo Año - Danza Clásica", nombre: "Pas de deux", horas: 4, tipo: "practica", obs: null },
      { grado: "7mo Año - Danza Clásica", nombre: "Producción Escénica", horas: 2, tipo: "teorico-practica", obs: "Taller" },
      { grado: "7mo Año - Danza Clásica", nombre: "Danzas de Carácter", horas: 2, tipo: "practica", obs: null },

      // 8vo Año - Clásica
      { grado: "8vo Año - Danza Clásica", nombre: "Danza Clásica", horas: 10, tipo: "practica", obs: null },
      { grado: "8vo Año - Danza Clásica", nombre: "Danza Tradicional", horas: 2, tipo: "practica", obs: null },
      { grado: "8vo Año - Danza Clásica", nombre: "Danza Contemporánea", horas: 2, tipo: "practica", obs: null },
      { grado: "8vo Año - Danza Clásica", nombre: "Repertorio", horas: 5, tipo: "practica", obs: null },
      { grado: "8vo Año - Danza Clásica", nombre: "Proyecto Comunitario", horas: 4, tipo: "teorico-practica", obs: "40 horas distribuidas en el año escolar" },
      { grado: "8vo Año - Danza Clásica", nombre: "Integración Artística - Profesional", horas: 2, tipo: "practica", obs: null },

      // ==========================================
      // ESPECIALIDAD: DANZA TRADICIONAL (5º a 8º Año)
      // ==========================================
      // 5to Año - Tradicional
      { grado: "5to Año - Danza Tradicional", nombre: "Danza Tradicional", horas: 10, tipo: "practica", obs: null },
      { grado: "5to Año - Danza Tradicional", nombre: "Danza Clásica", horas: 2, tipo: "practica", obs: null },
      { grado: "5to Año - Danza Tradicional", nombre: "Danza Contemporánea", horas: 2, tipo: "practica", obs: null },
      { grado: "5to Año - Danza Tradicional", nombre: "Teoría de la Cultura", horas: 2, tipo: "teorica", obs: null },
      { grado: "5to Año - Danza Tradicional", nombre: "Indumentaria, Elementos e Imágenes Populares", horas: 2, tipo: "teorico-practica", obs: null },
      { grado: "5to Año - Danza Tradicional", nombre: "Kinesiología", horas: 1, tipo: "teorica", obs: null },
      { grado: "5to Año - Danza Tradicional", nombre: "Elementos del Teatro para la Danza Tradicional", horas: 2, tipo: "practica", obs: null },
      { grado: "5to Año - Danza Tradicional", nombre: "Apreciación Musical", horas: 1, tipo: "teorica", obs: "Aplicada a la especialidad" },
      { grado: "5to Año - Danza Tradicional", nombre: "Preparación Física", horas: 2, tipo: "practica", obs: null },

      // 6to Año - Tradicional
      { grado: "6to Año - Danza Tradicional", nombre: "Danza Tradicional", horas: 10, tipo: "practica", obs: null },
      { grado: "6to Año - Danza Tradicional", nombre: "Danza Clásica", horas: 2, tipo: "practica", obs: null },
      { grado: "6to Año - Danza Tradicional", nombre: "Danza Contemporánea", horas: 2, tipo: "practica", obs: null },
      { grado: "6to Año - Danza Tradicional", nombre: "Historia de las Tradiciones Venezolanas", horas: 2, tipo: "teorica", obs: null },
      { grado: "6to Año - Danza Tradicional", nombre: "Indumentaria, Elementos e Imágenes Populares", horas: 2, tipo: "teorico-practica", obs: null },
      { grado: "6to Año - Danza Tradicional", nombre: "Elementos del Teatro para la Danza Tradicional", horas: 2, tipo: "practica", obs: null },
      { grado: "6to Año - Danza Tradicional", nombre: "Apreciación Musical", horas: 1, tipo: "teorica", obs: "Aplicada a la especialidad" },
      { grado: "6to Año - Danza Tradicional", nombre: "Preparación Física", horas: 2, tipo: "practica", obs: null },

      // 7mo Año - Tradicional
      { grado: "7mo Año - Danza Tradicional", nombre: "Danza Tradicional", horas: 10, tipo: "practica", obs: null },
      { grado: "7mo Año - Danza Tradicional", nombre: "Danza Clásica", horas: 2, tipo: "practica", obs: null },
      { grado: "7mo Año - Danza Tradicional", nombre: "Danza Contemporánea", horas: 2, tipo: "practica", obs: null },
      { grado: "7mo Año - Danza Tradicional", nombre: "Danza Latinoamericana y Caribeña", horas: 2, tipo: "practica", obs: null },
      { grado: "7mo Año - Danza Tradicional", nombre: "Historia de las Tradiciones Venezolanas", horas: 2, tipo: "teorica", obs: null },
      { grado: "7mo Año - Danza Tradicional", nombre: "Indumentaria, Elementos e Imágenes Populares", horas: 2, tipo: "teorico-practica", obs: null },
      { grado: "7mo Año - Danza Tradicional", nombre: "Elementos del Teatro para la Danza Tradicional", horas: 2, tipo: "practica", obs: null },
      { grado: "7mo Año - Danza Tradicional", nombre: "Apreciación Musical", horas: 1, tipo: "teorica", obs: "Aplicada a la especialidad" },
      { grado: "7mo Año - Danza Tradicional", nombre: "Producción Artística", horas: 2, tipo: "teorico-practica", obs: null },

      // 8vo Año - Tradicional
      { grado: "8vo Año - Danza Tradicional", nombre: "Danza Tradicional", horas: 10, tipo: "practica", obs: "Producción artística" },
      { grado: "8vo Año - Danza Tradicional", nombre: "Danza Clásica", horas: 2, tipo: "practica", obs: null },
      { grado: "8vo Año - Danza Tradicional", nombre: "Danza Contemporánea", horas: 2, tipo: "practica", obs: null },
      { grado: "8vo Año - Danza Tradicional", nombre: "Danza Latinoamericana y Caribeña", horas: 2, tipo: "practica", obs: null },
      { grado: "8vo Año - Danza Tradicional", nombre: "Historia de las Tradiciones Venezolanas", horas: 2, tipo: "teorica", obs: null },
      { grado: "8vo Año - Danza Tradicional", nombre: "Análisis de la Proyección de la Danza Tradicional en Venezuela", horas: 2, tipo: "teorica", obs: null },
      { grado: "8vo Año - Danza Tradicional", nombre: "Proyecto Comunitario", horas: 4, tipo: "teorico-practica", obs: "40 horas distribuidas en el año escolar" },
      { grado: "8vo Año - Danza Tradicional", nombre: "Integración Artística - Profesional", horas: 2, tipo: "practica", obs: null },

      // ==========================================
      // ESPECIALIDAD: DANZA CONTEMPORÁNEA (5º a 8º Año)
      // ==========================================
      // 5to Año - Contemporánea
      { grado: "5to Año - Danza Contemporánea", nombre: "Danza Contemporánea", horas: 10, tipo: "practica", obs: null },
      { grado: "5to Año - Danza Contemporánea", nombre: "Danza Tradicional", horas: 2, tipo: "practica", obs: null },
      { grado: "5to Año - Danza Contemporánea", nombre: "Danza Clásica", horas: 4, tipo: "practica", obs: null },
      { grado: "5to Año - Danza Contemporánea", nombre: "Historia y Precursores de la Danza Contemporánea", horas: 1, tipo: "teorica", obs: null },
      { grado: "5to Año - Danza Contemporánea", nombre: "Preparación Física", horas: 2, tipo: "practica", obs: null },
      { grado: "5to Año - Danza Contemporánea", nombre: "Composición Coreográfica", horas: 2, tipo: "practica", obs: null },
      { grado: "5to Año - Danza Contemporánea", nombre: "Kinesiología", horas: 1, tipo: "teorica", obs: null },
      { grado: "5to Año - Danza Contemporánea", nombre: "Música", horas: 1, tipo: "teorica", obs: null },

      // 6to Año - Contemporánea
      { grado: "6to Año - Danza Contemporánea", nombre: "Danza Contemporánea", horas: 10, tipo: "practica", obs: null },
      { grado: "6to Año - Danza Contemporánea", nombre: "Danza Tradicional", horas: 2, tipo: "practica", obs: null },
      { grado: "6to Año - Danza Contemporánea", nombre: "Danza Clásica", horas: 4, tipo: "practica", obs: null },
      { grado: "6to Año - Danza Contemporánea", nombre: "Preparación Física", horas: 2, tipo: "practica", obs: null },
      { grado: "6to Año - Danza Contemporánea", nombre: "Composición Coreográfica", horas: 3, tipo: "practica", obs: null },
      { grado: "6to Año - Danza Contemporánea", nombre: "Música", horas: 1, tipo: "teorica", obs: null },

      // 7mo Año - Contemporánea
      { grado: "7mo Año - Danza Contemporánea", nombre: "Danza Contemporánea", horas: 10, tipo: "practica", obs: null },
      { grado: "7mo Año - Danza Contemporánea", nombre: "Danza Tradicional", horas: 2, tipo: "practica", obs: null },
      { grado: "7mo Año - Danza Contemporánea", nombre: "Danza Clásica", horas: 2, tipo: "practica", obs: null },
      { grado: "7mo Año - Danza Contemporánea", nombre: "Preparación Física", horas: 2, tipo: "practica", obs: null },
      { grado: "7mo Año - Danza Contemporánea", nombre: "Historia y Precursores de la Danza Contemporánea en Venezuela", horas: 1, tipo: "teorica", obs: null },
      { grado: "7mo Año - Danza Contemporánea", nombre: "Composición Coreográfica", horas: 4, tipo: "practica", obs: null },
      { grado: "7mo Año - Danza Contemporánea", nombre: "Producción Escénica", horas: 2, tipo: "teorico-practica", obs: null },
      { grado: "7mo Año - Danza Contemporánea", nombre: "Técnicas Aplicadas a la Danza Contemporánea", horas: 1, tipo: "practica", obs: null },

      // 8vo Año - Contemporánea
      { grado: "8vo Año - Danza Contemporánea", nombre: "Danza Contemporánea", horas: 10, tipo: "practica", obs: null },
      { grado: "8vo Año - Danza Contemporánea", nombre: "Danza Tradicional", horas: 2, tipo: "practica", obs: null },
      { grado: "8vo Año - Danza Contemporánea", nombre: "Danza Clásica", horas: 2, tipo: "practica", obs: null },
      { grado: "8vo Año - Danza Contemporánea", nombre: "Preparación Física", horas: 2, tipo: "practica", obs: null },
      { grado: "8vo Año - Danza Contemporánea", nombre: "Repertorio Contemporáneo", horas: 5, tipo: "practica", obs: null },
      { grado: "8vo Año - Danza Contemporánea", nombre: "Técnicas Aplicadas a la Danza Contemporánea", horas: 1, tipo: "practica", obs: null },
      { grado: "8vo Año - Danza Contemporánea", nombre: "Proyecto Comunitario", horas: 4, tipo: "teorico-practica", obs: "40 horas distribuidas en el año escolar" },
      { grado: "8vo Año - Danza Contemporánea", nombre: "Integración Artística - Profesional", horas: 2, tipo: "practica", obs: null }
    ];

    let materiasCount = 0;
    for (const item of mallaCurricular) {
      const gradoId = gradoMap[item.grado];
      if (!gradoId) {
        console.warn(`Grado no encontrado para: ${item.grado}`);
        continue;
      }

      // Upsert materia por nombre_materia y ano_materia
      const existRes = await client.query(`
        SELECT "Id_materia" FROM "Materia" 
        WHERE "nombre_materia" = $1 AND "ano_materia" = $2
      `, [item.nombre, gradoId]);

      if (existRes.rows.length === 0) {
        await client.query(`
          INSERT INTO "Materia" ("nombre_materia", "ano_materia", "tipo_materia", "horas_semanales", "observaciones")
          VALUES ($1, $2, $3, $4, $5)
        `, [item.nombre, gradoId, item.tipo, item.horas, item.obs]);
      } else {
        await client.query(`
          UPDATE "Materia" 
          SET "tipo_materia" = $1, "horas_semanales" = $2, "observaciones" = $3
          WHERE "Id_materia" = $4
        `, [item.tipo, item.horas, item.obs, existRes.rows[0].Id_materia]);
      }
      materiasCount++;
    }

    // 5. Crear Año Académico y Lapsos por defecto si no existen
    console.log("📌 Verificando Año Académico y Lapsos activos...");
    const anoRes = await client.query(`SELECT "Id_ano" FROM "Ano_Academico" WHERE "activo" = true LIMIT 1`);
    let anoId;
    if (anoRes.rows.length === 0) {
      const currentYear = new Date().getFullYear();
      const insertAno = await client.query(`
        INSERT INTO "Ano_Academico" ("nombre_ano", "estatus_ano", "inicio_ano", "fin_ano", "activo")
        VALUES ($1, 'activo', $2, $3, true)
        RETURNING "Id_ano"
      `, [`${currentYear} - ${currentYear + 1}`, `${currentYear}-09-15`, `${currentYear + 1}-07-31`]);
      anoId = insertAno.rows[0].Id_ano;

      // Crear 3 lapsos
      const lapsos = [
        { nombre: "I LAPSO", inicio: `${currentYear}-09-15`, fin: `${currentYear}-12-15` },
        { nombre: "II LAPSO", inicio: `${currentYear + 1}-01-10`, fin: `${currentYear + 1}-04-05` },
        { nombre: "III LAPSO", inicio: `${currentYear + 1}-04-15`, fin: `${currentYear + 1}-07-15` }
      ];

      for (const lap of lapsos) {
        await client.query(`
          INSERT INTO "Lapso" ("nombre_lapso", "inicio_lapso", "fin_lapso", "Id_ano")
          VALUES ($1, $2, $3, $4)
        `, [lap.nombre, lap.inicio, lap.fin, anoId]);
      }
      console.log("✅ Año académico y Lapsos I, II y III creados.");
    }

    await client.query("COMMIT");
    console.log(`\n🎉 Población completada con éxito!`);
    console.log(`- ${Object.keys(gradoMap).length} Grados y Niveles de Danza registrados.`);
    console.log(`- ${materiasCount} Materias registradas con distinción Práctica / Teórica y horas semanales.`);
    process.exit(0);
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("❌ Error poblando malla curricular:", error);
    process.exit(1);
  } finally {
    client.release();
  }
}

seedMallaEndanza();
