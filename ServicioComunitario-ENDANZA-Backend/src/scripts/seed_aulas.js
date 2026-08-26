// Archivo: backend/src/scripts/seed_aulas.js
import { db } from "../db/connection.database.js";

const aulasData = [
  { nombre: "Salón Rosado", tipoClase: "Práctica" },
  { nombre: "Salón Azul", tipoClase: "Práctica" },
  { nombre: "Salón Violeta", tipoClase: "Teórico-Práctica" },
  { nombre: "Salón Amarillo", tipoClase: "Práctica" },
  { nombre: "Salón Blanco", tipoClase: "Práctica" },
  { nombre: "Patio", tipoClase: "Práctica" },
  { nombre: "Salón Gris", tipoClase: "Práctica" },
  { nombre: "Salón de Colores I", tipoClase: "Práctica" },
  { nombre: "Salón de Colores II", tipoClase: "Práctica" },
  { nombre: "Tarima", tipoClase: "Práctica" },
  { nombre: "Placa I", tipoClase: "Práctica" },
  { nombre: "Placa II", tipoClase: "Práctica" },
  { nombre: "Placa III", tipoClase: "Práctica" },
  { nombre: "Salón Verde", tipoClase: "Teórica" },
  { nombre: "Área de Cafetín", tipoClase: "Común / Usos Múltiples" },
  { nombre: "Salón Nutrición", tipoClase: "Teórico-Práctica" }
];

export async function seedAulas() {
  const client = await db.pool.connect();
  try {
    console.log("🚀 Iniciando población de Aulas y Ambientes de Aprendizaje...");
    await client.query("BEGIN");

    // 1. Asegurar Tipos de Clase
    const tipos = ["Práctica", "Teórica", "Teórico-Práctica", "Común / Usos Múltiples"];
    const tipoMap = {};

    for (const tipo of tipos) {
      let res = await client.query(
        'SELECT "Id_tipo_clase" FROM "Tipo_Clase" WHERE UPPER("nombre_tipo_clase") = $1',
        [tipo.toUpperCase()]
      );

      let tipoId;
      if (res.rows.length === 0) {
        const ins = await client.query(
          'INSERT INTO "Tipo_Clase" ("nombre_tipo_clase") VALUES ($1) RETURNING "Id_tipo_clase"',
          [tipo]
        );
        tipoId = ins.rows[0].Id_tipo_clase;
      } else {
        tipoId = res.rows[0].Id_tipo_clase;
      }
      tipoMap[tipo] = tipoId;
    }

    // 2. Insertar o actualizar cada Aula
    let insertadas = 0;
    let actualizadas = 0;

    for (const aula of aulasData) {
      const tipoId = tipoMap[aula.tipoClase] || tipoMap["Práctica"];

      const exist = await client.query(
        'SELECT "Id_aula" FROM "Aula" WHERE UPPER("nombre_aula") = $1',
        [aula.nombre.toUpperCase()]
      );

      if (exist.rows.length === 0) {
        await client.query(
          'INSERT INTO "Aula" ("nombre_aula", "Id_tipo_clase") VALUES ($1, $2)',
          [aula.nombre, tipoId]
        );
        insertadas++;
      } else {
        await client.query(
          'UPDATE "Aula" SET "Id_tipo_clase" = $1 WHERE "Id_aula" = $2',
          [tipoId, exist.rows[0].Id_aula]
        );
        actualizadas++;
      }
    }

    await client.query("COMMIT");
    console.log(`✅ Aulas procesadas con éxito:`);
    console.log(`   ➕ Nuevas aulas insertadas: ${insertadas}`);
    console.log(`   🔄 Aulas existentes actualizadas: ${actualizadas}`);

    // Mostrar listado final
    const finalAulas = await db.query(`
      SELECT a."Id_aula", a."nombre_aula", tc."nombre_tipo_clase" 
      FROM "Aula" a
      LEFT JOIN "Tipo_Clase" tc ON a."Id_tipo_clase" = tc."Id_tipo_clase"
      ORDER BY a."Id_aula" ASC
    `);
    console.table(finalAulas.rows);

    return finalAulas.rows;
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("❌ Error poblando Aulas:", error);
    throw error;
  } finally {
    client.release();
  }
}

// Ejecutar directamente si se llama el script
if (process.argv[1]?.includes("seed_aulas.js")) {
  seedAulas()
    .then(() => {
      console.log("🏁 Población de Aulas finalizada.");
      process.exit(0);
    })
    .catch((err) => {
      console.error(err);
      process.exit(1);
    });
}
