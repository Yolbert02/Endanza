import 'dotenv/config';
import { db } from '../db/connection.database.js';

async function migrate() {
  try {
    console.log('🚀 Iniciando migración de Usuario_Rol...');

    await db.query(`
      CREATE TABLE IF NOT EXISTS "Usuario_Rol" (
        "Id_usuario" INT NOT NULL REFERENCES "Usuario"("Id_usuario") ON DELETE CASCADE,
        "Id_rol" INT NOT NULL REFERENCES "Rol"("Id_rol") ON DELETE CASCADE,
        "creado_en" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY ("Id_usuario", "Id_rol")
      )
    `);
    console.log('✅ Tabla Usuario_Rol creada o verificada');

    // 1. Poblar con los roles actuales de Usuario
    const res1 = await db.query(`
      INSERT INTO "Usuario_Rol" ("Id_usuario", "Id_rol")
      SELECT "Id_usuario", "Id_rol" FROM "Usuario"
      WHERE "Id_rol" IS NOT NULL
      ON CONFLICT DO NOTHING
    `);
    console.log(`✅ Roles base migrados desde Usuario: ${res1.rowCount} filas insertadas`);

    // 2. Asociar rol 2 (Docente) para cualquier usuario registrado en Profesor
    const res2 = await db.query(`
      INSERT INTO "Usuario_Rol" ("Id_usuario", "Id_rol")
      SELECT DISTINCT "Id_usuario", 2 FROM "Profesor"
      WHERE "Id_usuario" IS NOT NULL
      ON CONFLICT DO NOTHING
    `);
    console.log(`✅ Roles de Profesor asegurados en Usuario_Rol: ${res2.rowCount} filas insertadas`);

    // 3. Asociar rol 4 (Representante) para cualquier usuario registrado en Representante
    const res3 = await db.query(`
      INSERT INTO "Usuario_Rol" ("Id_usuario", "Id_rol")
      SELECT DISTINCT "Id_usuario", 4 FROM "Representante"
      WHERE "Id_usuario" IS NOT NULL
      ON CONFLICT DO NOTHING
    `);
    console.log(`✅ Roles de Representante asegurados en Usuario_Rol: ${res3.rowCount} filas insertadas`);

    // 4. Verificar usuarios con múltiples roles
    const multiRoles = await db.query(`
      SELECT ur."Id_usuario", u."nombre", u."apellido", u."cedula", string_agg(r."tipo_rol", ', ') as roles
      FROM "Usuario_Rol" ur
      JOIN "Usuario" u ON ur."Id_usuario" = u."Id_usuario"
      JOIN "Rol" r ON ur."Id_rol" = r."Id_rol"
      GROUP BY ur."Id_usuario", u."nombre", u."apellido", u."cedula"
      HAVING count(*) > 1
    `);
    console.log('👥 Usuarios con Rol Dual detectados:', multiRoles.rows);

    process.exit(0);
  } catch (error) {
    console.error('❌ Error en migración:', error);
    process.exit(1);
  }
}

migrate();
