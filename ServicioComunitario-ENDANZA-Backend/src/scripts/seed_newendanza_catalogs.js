import { db } from "../db/connection.database.js";

export async function seedCatalogs() {
  const client = await db.pool.connect();
  try {
    await client.query("BEGIN");
    console.log("🌱 [Seed] Iniciando inserción de catálogos base en NewEndanza...");

    // 1. ESPECIALIDADES
    console.log("🩰 Insertando especialidades...");
    const especialidades = [
      {
        nombre: 'Danza Clásica',
        descripcion: 'Formación especializada en técnica clásica académica y repertorio.',
        activo: true
      },
      {
        nombre: 'Danza Tradicional',
        descripcion: 'Formación especializada en bailes tradicionales venezolanos, latinoamericanos y cultura popular.',
        activo: true
      },
      {
        nombre: 'Danza Contemporánea',
        descripcion: 'Formación especializada en técnicas contemporáneas, expresión corporal y composición.',
        activo: true
      }
    ];

    for (const esp of especialidades) {
      await client.query(`
        INSERT INTO especialidad (nombre_especialidad, descripcion, activo)
        VALUES ($1, $2, $3)
        ON CONFLICT DO NOTHING
      `, [esp.nombre, esp.descripcion, esp.activo]);
    }

    // 2. NIVELES DE DANZA
    console.log("🎭 Insertando niveles de danza...");
    const nivelesDanza = [
      'Pre-Ballet',
      'Preparatorio',
      '1er Año',
      '2do Año',
      '3er Año',
      '4to Año',
      '5to Año - Danza Clásica',
      '6to Año - Danza Clásica',
      '7mo Año - Danza Clásica',
      '8vo Año - Danza Clásica',
      '5to Año - Danza Tradicional',
      '6to Año - Danza Tradicional',
      '7mo Año - Danza Tradicional',
      '8vo Año - Danza Tradicional',
      '5to Año - Danza Contemporánea',
      '6to Año - Danza Contemporánea',
      '7mo Año - Danza Contemporánea',
      '8vo Año - Danza Contemporánea'
    ];

    for (const nd of nivelesDanza) {
      await client.query(`
        INSERT INTO nivel_danza (nivel_danza)
        VALUES ($1)
        ON CONFLICT DO NOTHING
      `, [nd]);
    }

    // 3. NIVELES ESCOLARES (Educación Regular)
    console.log("📚 Insertando niveles escolares...");
    const nivelesEscolares = [
      'Preescolar',
      '1er Grado',
      '2do Grado',
      '3er Grado',
      '4to Grado',
      '5to Grado',
      '6to Grado',
      '1er Año',
      '2do Año',
      '3er Año',
      '4to Año',
      '5to Año',
      'Universitario'
    ];

    for (const ne of nivelesEscolares) {
      await client.query(`
        INSERT INTO nivel_escolar (nivel)
        VALUES ($1)
        ON CONFLICT DO NOTHING
      `, [ne]);
    }

    // 4. TIPOS DE AULA
    console.log("🏫 Insertando tipos de aula...");
    const tiposAula = [
      'Práctica / Danza',
      'Teórica',
      'Especializada',
      'Área Común'
    ];

    const tipoAulaIds = {};
    for (const ta of tiposAula) {
      const res = await client.query(`
        INSERT INTO tipo_aula (nombre_tipo_aula)
        VALUES ($1)
        ON CONFLICT DO NOTHING
        RETURNING id_tipo_aula
      `, [ta]);

      if (res.rows.length > 0) {
        tipoAulaIds[ta] = res.rows[0].id_tipo_aula;
      } else {
        const found = await client.query(`SELECT id_tipo_aula FROM tipo_aula WHERE nombre_tipo_aula = $1`, [ta]);
        tipoAulaIds[ta] = found.rows[0]?.id_tipo_aula;
      }
    }

    // 5. AULAS
    console.log("🚪 Insertando aulas...");
    const aulas = [
      { nombre: 'Salón Rosado', tipo: 'Práctica / Danza' },
      { nombre: 'Salón Azul', tipo: 'Práctica / Danza' },
      { nombre: 'Salón Violeta', tipo: 'Especializada' },
      { nombre: 'Salón Amarillo', tipo: 'Práctica / Danza' },
      { nombre: 'Salón Blanco', tipo: 'Práctica / Danza' },
      { nombre: 'Patio', tipo: 'Práctica / Danza' },
      { nombre: 'Salón Gris', tipo: 'Práctica / Danza' },
      { nombre: 'Salón de Colores I', tipo: 'Práctica / Danza' },
      { nombre: 'Salón de Colores II', tipo: 'Práctica / Danza' },
      { nombre: 'Tarima', tipo: 'Práctica / Danza' },
      { nombre: 'Placa I', tipo: 'Práctica / Danza' },
      { nombre: 'Placa II', tipo: 'Práctica / Danza' },
      { nombre: 'Placa III', tipo: 'Práctica / Danza' },
      { nombre: 'Salón Verde', tipo: 'Teórica' },
      { nombre: 'Área de Cafetín', tipo: 'Área Común' },
      { nombre: 'Salón Nutrición', tipo: 'Especializada' }
    ];

    for (const a of aulas) {
      const tipoId = tipoAulaIds[a.tipo] || 1;
      await client.query(`
        INSERT INTO aula (nombre_aula, id_tipo_aula)
        VALUES ($1, $2)
        ON CONFLICT DO NOTHING
      `, [a.nombre, tipoId]);
    }

    // 6. DÍAS DE LA SEMANA
    console.log("📅 Insertando días...");
    const dias = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo'
    ];

    const diaIds = {};
    for (const d of dias) {
      const res = await client.query(`
        INSERT INTO dia (nombre_dia)
        VALUES ($1)
        ON CONFLICT DO NOTHING
        RETURNING id_dia
      `, [d]);

      if (res.rows.length > 0) {
        diaIds[d] = res.rows[0].id_dia;
      } else {
        const found = await client.query(`SELECT id_dia FROM dia WHERE nombre_dia = $1`, [d]);
        diaIds[d] = found.rows[0]?.id_dia;
      }
    }

    // 7. SEGUROS MÉDICOS
    console.log("🏥 Insertando seguros médicos...");
    const seguros = [
      'Público (IVSS / Barrio Adentro)',
      'Privado',
      'No posee seguro'
    ];

    for (const s of seguros) {
      await client.query(`
        INSERT INTO seguro_medico (tipo_seguro)
        VALUES ($1)
        ON CONFLICT DO NOTHING
      `, [s]);
    }

    // 8. TIPOS DE EVALUACIÓN
    console.log("📝 Insertando tipos de evaluación...");
    const tiposEvaluacion = [
      'Evaluación Práctica',
      'Evaluación Teórica',
      'Presentación / Muestra',
      'Examen Diagnóstico'
    ];

    for (const te of tiposEvaluacion) {
      await client.query(`
        INSERT INTO tipo_evaluacion (nombre_evaluacion)
        VALUES ($1)
        ON CONFLICT DO NOTHING
      `, [te]);
    }

    // 9. BLOQUES DE TIEMPO (Lunes a Viernes, tardes 2:00 PM a 6:00 PM)
    console.log("⏰ Insertando bloques de tiempo...");
    const bloquesBase = [
      { nombre: '02:00 PM - 02:45 PM', inicio: '14:00:00', fin: '14:45:00' },
      { nombre: '02:45 PM - 03:30 PM', inicio: '14:45:00', fin: '15:30:00' },
      { nombre: '03:30 PM - 04:15 PM', inicio: '15:30:00', fin: '16:15:00' },
      { nombre: '04:15 PM - 05:00 PM', inicio: '16:15:00', fin: '17:00:00' },
      { nombre: '05:00 PM - 05:45 PM', inicio: '17:00:00', fin: '17:45:00' },
      { nombre: '05:45 PM - 06:30 PM', inicio: '17:45:00', fin: '18:30:00' }
    ];

    for (const d of ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado']) {
      const idDia = diaIds[d];
      if (idDia) {
        for (const b of bloquesBase) {
          await client.query(`
            INSERT INTO tiempo_bloque (nombre_bloque, inicio_bloque, fin_bloque, id_dia)
            VALUES ($1, $2, $3, $4)
            ON CONFLICT DO NOTHING
          `, [b.nombre, b.inicio, b.fin, idDia]);
        }
      }
    }

    await client.query("COMMIT");
    console.log("✅ Catálogos base de NewEndanza sembrados exitosamente.");
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("❌ Error sembrando catálogos:", error);
    throw error;
  } finally {
    client.release();
  }
}

// Ejecución directa por CLI
if (process.argv[1]?.endsWith('seed_newendanza_catalogs.js')) {
  seedCatalogs()
    .then(() => process.exit(0))
    .catch(() => process.exit(1));
}
