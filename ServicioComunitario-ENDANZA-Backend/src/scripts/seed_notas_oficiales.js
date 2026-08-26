// Archivo: backend/src/scripts/seed_notas_oficiales.js
import { db } from "../db/connection.database.js";

// Datos de las 5 actas de calificaciones oficiales ENDANZA para el Año Escolar 2025-2026
const actasData = [
  // =========================================================================
  // ACTA 1: Grado 6to, Sección "C" (6to Año - Danza Tradicional)
  // =========================================================================
  {
    grado: "6to Año - Danza Tradicional",
    seccionNombre: "C",
    materiaHeaders: [
      { name: "Danza Tradicional", lapsos: 3, tipo: "practica" },
      { name: "Danza Contemporánea", lapsos: 3, tipo: "practica" },
      { name: "Danza Clásica", lapsos: 3, tipo: "practica" },
      { name: "Preparación Física", lapsos: 3, tipo: "practica" },
      { name: "Historia de las Tradiciones Venezolanas", lapsos: 2, tipo: "teorica" },
      { name: "Música", lapsos: 2, tipo: "teorica" },
      { name: "Producción Escénica", lapsos: 2, tipo: "teorico-practica" }
    ],
    estudiantes: [
      {
        nombre: "NATHALIA SARAY",
        apellido: "BONILLA PULIDO",
        notas: [
          [16, 19, 16], // Danza Tradicional
          [12, 12, 7],  // Danza Contemporánea
          [16, 17, 17], // Danza Clásica
          [18, 18, 18], // Preparación Física
          [17, 16],     // Historia de las Tradiciones
          [16, 16],     // Música
          [14, 15]      // Producción Escénica
        ]
      },
      {
        nombre: "DARYANGEL VICTORIA",
        apellido: "CHACON CONTRERAS",
        notas: [
          [14, 19, 18], // Danza Tradicional
          [13, 13, 10], // Danza Contemporánea
          [16, 17, 17], // Danza Clásica
          [18, 19, 19], // Preparación Física
          [15, 16],     // Historia de las Tradiciones
          [12, 18],     // Música
          [13, 13]      // Producción Escénica
        ]
      },
      {
        nombre: "EMILY ALICEC",
        apellido: "MORA GUERRERO",
        notas: [
          [18, 20, 16], // Danza Tradicional
          [13, 14, 12], // Danza Contemporánea
          [15, 18, 17], // Danza Clásica
          [20, 20, 20], // Preparación Física
          [18, 18],     // Historia de las Tradiciones
          [17, 20],     // Música
          [15, 15]      // Producción Escénica
        ]
      }
    ]
  },

  // =========================================================================
  // ACTA 2: Grado 7mo, Sección "A" (7mo Año - Danza Clásica)
  // =========================================================================
  {
    grado: "7mo Año - Danza Clásica",
    seccionNombre: "A",
    materiaHeaders: [
      { name: "Danza Clásica", lapsos: 3, tipo: "practica" },
      { name: "Danza Contemporánea", lapsos: 3, tipo: "practica" },
      { name: "Danza Tradicional", lapsos: 3, tipo: "practica" },
      { name: "Repertorio", lapsos: 3, tipo: "practica" },
      { name: "Composición Coreográfica", lapsos: 2, tipo: "practica" },
      { name: "Preparación Física", lapsos: 3, tipo: "practica" },
      { name: "Producción Escénica", lapsos: 2, tipo: "teorico-practica" }
    ],
    estudiantes: [
      {
        nombre: "GABRIELA ALEXANDRA",
        apellido: "ANDRADE RUMBOS",
        notas: [
          [17, 18, 18], // Danza Clásica
          [17, 16, 14], // Danza Contemporánea
          [15, 16, 17], // Danza Tradicional
          [17, 19, 18], // Repertorio
          [17, 17],     // Composición Coreográfica
          [18, 19, 20], // Preparación Física
          [16, 17]      // Producción Escénica
        ]
      },
      {
        nombre: "ZOE JOHENNY",
        apellido: "ARIAS VIVAS",
        notas: [
          [17, 19, 18], // Danza Clásica
          [19, 17, 17], // Danza Contemporánea
          [18, 19, 18], // Danza Tradicional
          [16, 20, 17], // Repertorio
          [18, 17],     // Composición Coreográfica
          [18, 19, 20], // Preparación Física
          [16, 17]      // Producción Escénica
        ]
      },
      {
        nombre: "EIMY JULLIETH",
        apellido: "CONTRERAS COLMENARES",
        notas: [
          [16, 15, 15], // Danza Clásica
          [17, 15, 14], // Danza Contemporánea
          [17, 17, 18], // Danza Tradicional
          [16, 17, 16], // Repertorio
          [18, 18],     // Composición Coreográfica
          [16, 17, 20], // Preparación Física
          [16, 16]      // Producción Escénica
        ]
      },
      {
        nombre: "ROSSY VALENTINA",
        apellido: "MARQUEZ ROSALES",
        notas: [
          [16, 16, 16], // Danza Clásica
          [18, 16, 14], // Danza Contemporánea
          [17, 18, 19], // Danza Tradicional
          [16, 17, 17], // Repertorio
          [17, 17],     // Composición Coreográfica
          [18, 19, 20], // Preparación Física
          [17, 17]      // Producción Escénica
        ]
      }
    ]
  },

  // =========================================================================
  // ACTA 3: Grado 7mo, Sección "B" (7mo Año - Danza Contemporánea)
  // =========================================================================
  {
    grado: "7mo Año - Danza Contemporánea",
    seccionNombre: "B",
    materiaHeaders: [
      { name: "Danza Contemporánea", lapsos: 3, tipo: "practica" },
      { name: "Danza Clásica", lapsos: 3, tipo: "practica" },
      { name: "Danza Tradicional", lapsos: 3, tipo: "practica" },
      { name: "Composición Coreográfica", lapsos: 2, tipo: "practica" },
      { name: "Preparación Física", lapsos: 3, tipo: "practica" },
      { name: "Historia y Precursores de la Danza Contemporánea en Venezuela", lapsos: 2, tipo: "teorica" }
    ],
    estudiantes: [
      {
        nombre: "ALLISON NATHALÍ",
        apellido: "AMAYA RAMÍREZ",
        notas: [
          [15, 13, 14], // Danza Contemporánea
          [17, 17, 16], // Danza Clásica
          [15, 16, 15], // Danza Tradicional
          [16, 17],     // Composición Coreográfica
          [18, 17, 20], // Preparación Física
          [15, 17]      // Historia de los Precursores
        ]
      },
      {
        nombre: "MANUELA ALEJANDRA",
        apellido: "NÚÑEZ MORENO",
        notas: [
          [18, 18, 16], // Danza Contemporánea
          [18, 19, 18], // Danza Clásica
          [15, 18, 17], // Danza Tradicional
          [18, 17],     // Composición Coreográfica
          [18, 18, 20], // Preparación Física
          [17, 18]      // Historia de los Precursores
        ]
      },
      {
        nombre: "ARIADNA ISABELLA",
        apellido: "ROJAS RANGEL",
        notas: [
          [16, 16, 15], // Danza Contemporánea
          [18, 18, 13], // Danza Clásica
          [18, 18, 18], // Danza Tradicional
          [18, 17],     // Composición Coreográfica
          [17, 18, 20], // Preparación Física
          [17, 18]      // Historia de los Precursores
        ]
      }
    ]
  },

  // =========================================================================
  // ACTA 4: Grado 7mo, Sección "C" (7mo Año - Danza Tradicional)
  // =========================================================================
  {
    grado: "7mo Año - Danza Tradicional",
    seccionNombre: "C",
    materiaHeaders: [
      { name: "Danza Tradicional", lapsos: 3, tipo: "practica" },
      { name: "Danza Contemporánea", lapsos: 3, tipo: "practica" },
      { name: "Danza Clásica", lapsos: 3, tipo: "practica" },
      { name: "Danza Latinoamericana y Caribeña", lapsos: 3, tipo: "practica" },
      { name: "Historia de las Tradiciones Venezolanas", lapsos: 2, tipo: "teorica" },
      { name: "Producción Artística", lapsos: 2, tipo: "teorico-practica" },
      { name: "Preparación Física", lapsos: 3, tipo: "practica" }
    ],
    estudiantes: [
      {
        nombre: "JAVIANA SOFIA",
        apellido: "DAVILA MONTERO",
        notas: [
          [18, 18, 19], // Danza Tradicional
          [16, 14, 11], // Danza Contemporánea
          [17, 16, 16], // Danza Clásica
          [19, 19, 20], // Danza Latinoamericana
          [17, 17],     // Historia de las Tradiciones
          [12, 17],     // Producción Escénica / Artística
          [18, 16, 17]  // Preparación Física
        ]
      },
      {
        nombre: "CAMILA VALENTINA",
        apellido: "DAVILA SANCHEZ",
        notas: [
          [17, 13, 17], // Danza Tradicional
          [13, 10, 8],  // Danza Contemporánea
          [17, 16, 16], // Danza Clásica
          [18, 14, 20], // Danza Latinoamericana
          [18, 17],     // Historia de las Tradiciones
          [13, 15],     // Producción Escénica / Artística
          [17, 14, 16]  // Preparación Física
        ]
      },
      {
        nombre: "MARIANGEL HELIT",
        apellido: "GARZON MORALES",
        notas: [
          [16, 18, 16], // Danza Tradicional
          [16, 14, 13], // Danza Contemporánea
          [17, 16, 16], // Danza Clásica
          [16, 17, 18], // Danza Latinoamericana
          [16, 14],     // Historia de las Tradiciones
          [13, 16],     // Producción Escénica / Artística
          [17, 10, 14]  // Preparación Física
        ]
      },
      {
        nombre: "DARY",
        apellido: "OCANA DELGADO",
        notas: [
          [18, 14, 16], // Danza Tradicional
          [14, 12, 3],  // Danza Contemporánea
          [17, 16, 16], // Danza Clásica
          [18, 12, 20], // Danza Latinoamericana
          [18, 17],     // Historia de las Tradiciones
          [14, 16],     // Producción Escénica / Artística
          [17, 16, 17]  // Preparación Física
        ]
      }
    ]
  },

  // =========================================================================
  // ACTA 5: Grado 8vo, Sección "A" (8vo Año - Danza Clásica)
  // =========================================================================
  {
    grado: "8vo Año - Danza Clásica",
    seccionNombre: "A",
    materiaHeaders: [
      { name: "Danza Clásica", lapsos: 3, tipo: "practica" },
      { name: "Danza Contemporánea", lapsos: 3, tipo: "practica" },
      { name: "Danza Tradicional", lapsos: 3, tipo: "practica" },
      { name: "Repertorio", lapsos: 3, tipo: "practica" },
      { name: "Preparación Física", lapsos: 3, tipo: "practica" }
    ],
    estudiantes: [
      {
        nombre: "ISABELLA ALESSANDRA",
        apellido: "AVENDAÑO BLANCO",
        notas: [
          [15, 17, 17], // Danza Clásica
          [13, 13, 12], // Danza Contemporánea
          [17, 15, 15], // Danza Tradicional
          [18, 18, 17], // Repertorio
          [19, 20, 18]  // Preparación Física
        ]
      },
      {
        nombre: "MARÍA VIRGINIA",
        apellido: "GARCÍA FERNÁNDEZ",
        notas: [
          [15, 16, 14], // Danza Clásica
          [7, 4, 0],    // Danza Contemporánea
          [16, 13, 14], // Danza Tradicional
          [17, 15, 17], // Repertorio
          [18, 20, 18]  // Preparación Física
        ]
      },
      {
        nombre: "MARÍA CAMILA",
        apellido: "MÚJICA VARGAS",
        notas: [
          [18, 19, 18], // Danza Clásica
          [14, 14, 16], // Danza Contemporánea
          [14, 18, 16], // Danza Tradicional
          [18, 17, 17], // Repertorio
          [20, 20, 20]  // Preparación Física
        ]
      },
      {
        nombre: "CAMILA ANDREA",
        apellido: "QUEVEDO REVERÓN",
        notas: [
          [17, 18, 16], // Danza Clásica
          [14, 13, 16], // Danza Contemporánea
          [13, 18, 15], // Danza Tradicional
          [17, 15, 17], // Repertorio
          [15, 20, 17]  // Preparación Física
        ]
      }
    ]
  }
];

export async function seedNotasOficiales() {
  const client = await db.pool.connect();
  try {
    console.log("🚀 Iniciando población de Notas Oficiales ENDANZA (2025-2026)...");
    await client.query("BEGIN");

    // 1. Asegurar tipo de evaluación
    let tipoEvalRes = await client.query('SELECT "Id_tipo_evaluacion" FROM "Tipo_Evaluacion" LIMIT 1');
    let tipoEvalId;
    if (tipoEvalRes.rows.length === 0) {
      const insTE = await client.query(`
        INSERT INTO "Tipo_Evaluacion" ("nombre_evaluacion")
        VALUES ('Evaluación de Lapso')
        RETURNING "Id_tipo_evaluacion"
      `);
      tipoEvalId = insTE.rows[0].Id_tipo_evaluacion;
    } else {
      tipoEvalId = tipoEvalRes.rows[0].Id_tipo_evaluacion;
    }

    // 2. Asegurar Año Académico 2025-2026
    let anoRes = await client.query('SELECT "Id_ano" FROM "Ano_Academico" WHERE "nombre_ano" IN (\'2025 - 2026\', \'2025-2026\')');
    let anoId;
    if (anoRes.rows.length === 0) {
      const insAno = await client.query(`
        INSERT INTO "Ano_Academico" ("nombre_ano", "estatus_ano", "inicio_ano", "fin_ano", "activo")
        VALUES ('2025 - 2026', 'activo', '2025-09-15', '2026-07-31', true)
        RETURNING "Id_ano"
      `);
      anoId = insAno.rows[0].Id_ano;
    } else {
      anoId = anoRes.rows[0].Id_ano;
    }

    // 3. Asegurar los 3 Lapsos para 2025-2026
    const lapsosConfig = [
      { nombre: "I LAPSO", inicio: "2025-09-15", fin: "2025-12-15" },
      { nombre: "II LAPSO", inicio: "2026-01-10", fin: "2026-04-05" },
      { nombre: "III LAPSO", inicio: "2026-04-15", fin: "2026-07-15" }
    ];
    const lapsoMap = {}; // 1, 2, 3 -> Id_lapso

    for (let lIndex = 0; lIndex < 3; lIndex++) {
      const lCfg = lapsosConfig[lIndex];
      let lapRes = await client.query(`
        SELECT "Id_lapso" FROM "Lapso" 
        WHERE "Id_ano" = $1 AND UPPER("nombre_lapso") = $2
      `, [anoId, lCfg.nombre]);

      let lapsoId;
      if (lapRes.rows.length === 0) {
        const insLap = await client.query(`
          INSERT INTO "Lapso" ("nombre_lapso", "inicio_lapso", "fin_lapso", "Id_ano")
          VALUES ($1, $2, $3, $4)
          RETURNING "Id_lapso"
        `, [lCfg.nombre, lCfg.inicio, lCfg.fin, anoId]);
        lapsoId = insLap.rows[0].Id_lapso;
      } else {
        lapsoId = lapRes.rows[0].Id_lapso;
      }
      lapsoMap[lIndex + 1] = lapsoId;
    }

    // 4. Procesar cada acta
    let totalNotasCargadas = 0;
    const boletinesHabilitados = new Set();

    for (const acta of actasData) {
      console.log(`\n📌 Procesando Acta: ${acta.grado} - Sección ${acta.seccionNombre}...`);

      // 4.1 Buscar Id_grado
      const gradoRes = await client.query('SELECT "Id_grado" FROM "Grado" WHERE "nombre_grado" = $1', [acta.grado]);
      if (gradoRes.rows.length === 0) {
        throw new Error(`Grado '${acta.grado}' no encontrado en tabla Grado`);
      }
      const gradoId = gradoRes.rows[0].Id_grado;

      // 4.2 Para cada materia del acta, buscar o crear en tabla Materia
      const materiasMap = []; // index -> { Id_materia, nombre, lapsos, tipo }
      for (const mHead of acta.materiaHeaders) {
        let matRes = await client.query(`
          SELECT "Id_materia" FROM "Materia" 
          WHERE "ano_materia" = $1 AND UPPER("nombre_materia") LIKE $2
        `, [gradoId, `%${mHead.name.trim().toUpperCase()}%`]);

        let materiaId;
        if (matRes.rows.length === 0) {
          // Crear materia si no existe
          const insMat = await client.query(`
            INSERT INTO "Materia" ("nombre_materia", "ano_materia", "tipo_materia", "horas_semanales")
            VALUES ($1, $2, $3, 2)
            RETURNING "Id_materia"
          `, [mHead.name, gradoId, mHead.tipo]);
          materiaId = insMat.rows[0].Id_materia;
        } else {
          materiaId = matRes.rows[0].Id_materia;
        }

        materiasMap.push({
          id: materiaId,
          nombre: mHead.name,
          lapsos: mHead.lapsos,
          tipo: mHead.tipo
        });
      }

      // 4.3 Para cada materia y lapso, asegurar Sección y Estructura de Evaluación
      const seccionLapsoMap = {}; // materiaId_lapsoNum -> { seccionId, estructuraId }

      for (let mIdx = 0; mIdx < materiasMap.length; mIdx++) {
        const mat = materiasMap[mIdx];

        for (let lNum = 1; lNum <= mat.lapsos; lNum++) {
          const lapsoId = lapsoMap[lNum];

          // Buscar o crear Sección
          let secRes = await client.query(`
            SELECT "Id_seccion" FROM "Seccion"
            WHERE "Id_materia" = $1 AND "Id_lapso" = $2 AND "Id_ano" = $3 AND "nombre_seccion" = $4
          `, [mat.id, lapsoId, anoId, acta.seccionNombre]);

          let seccionId;
          if (secRes.rows.length === 0) {
            const insSec = await client.query(`
              INSERT INTO "Seccion" ("nombre_seccion", "capacidad", "Id_materia", "Id_lapso", "Id_ano")
              VALUES ($1, 30, $2, $3, $4)
              RETURNING "Id_seccion"
            `, [acta.seccionNombre, mat.id, lapsoId, anoId]);
            seccionId = insSec.rows[0].Id_seccion;
          } else {
            seccionId = secRes.rows[0].Id_seccion;
          }

          // Buscar o crear Estructura_Evaluacion
          let eeRes = await client.query(`
            SELECT "Id_estructura_evaluacion" FROM "Estructura_Evaluacion"
            WHERE "Id_seccion" = $1 AND "Id_lapso" = $2 AND "numero_evaluacion" = 1
          `, [seccionId, lapsoId]);

          let estructuraId;
          if (eeRes.rows.length === 0) {
            const insEE = await client.query(`
              INSERT INTO "Estructura_Evaluacion" (
                "numero_evaluacion", "porcentaje_peso", "Id_seccion", "Id_tipo_evaluacion", "Id_lapso"
              ) VALUES (1, 100, $1, $2, $3)
              RETURNING "Id_estructura_evaluacion"
            `, [seccionId, tipoEvalId, lapsoId]);
            estructuraId = insEE.rows[0].Id_estructura_evaluacion;
          } else {
            estructuraId = eeRes.rows[0].Id_estructura_evaluacion;
          }

          seccionLapsoMap[`${mat.id}_${lNum}`] = {
            seccionId,
            estructuraId
          };
        }
      }

      // 4.4 Procesar notas por estudiante
      for (const estData of acta.estudiantes) {
        // Buscar estudiante en la BD
        let estRes = await client.query(`
          SELECT "Id_estudiante", "nombre", "apellido"
          FROM "Estudiante"
          WHERE (UPPER("nombre") LIKE $1 OR UPPER("apellido") LIKE $1)
            AND (UPPER("nombre") LIKE $2 OR UPPER("apellido") LIKE $2)
          LIMIT 1
        `, [
          `%${estData.nombre.split(" ")[0].toUpperCase()}%`,
          `%${estData.apellido.split(" ")[0].toUpperCase()}%`
        ]);

        let estudianteId;
        if (estRes.rows.length === 0) {
          // Si no existe, crearlo
          const insEst = await client.query(`
            INSERT INTO "Estudiante" (
              "nombre", "apellido", "cedula", "fecha_nacimiento", "genero", "seguro_escolar"
            ) VALUES ($1, $2, $3, '2010-01-01', 'Femenino', false)
            RETURNING "Id_estudiante"
          `, [
            estData.nombre,
            estData.apellido,
            `EST-ACTA-${Date.now().toString().slice(-4)}`
          ]);
          estudianteId = insEst.rows[0].Id_estudiante;
        } else {
          estudianteId = estRes.rows[0].Id_estudiante;
        }

        boletinesHabilitados.add(estudianteId);

        // Guardar cada calificación
        for (let mIdx = 0; mIdx < materiasMap.length; mIdx++) {
          const mat = materiasMap[mIdx];
          const notasMateria = estData.notas[mIdx]; // [notaL1, notaL2, notaL3]

          for (let lNum = 1; lNum <= notasMateria.length; lNum++) {
            const notaVal = notasMateria[lNum - 1];
            const secInfo = seccionLapsoMap[`${mat.id}_${lNum}`];

            if (!secInfo) continue;

            // Inscribir en Estudiante_Seccion si no está
            const existES = await client.query(`
              SELECT "Id_estudiante_seccion" FROM "Estudiante_Seccion"
              WHERE "Id_estudiante" = $1 AND "Id_seccion" = $2
            `, [estudianteId, secInfo.seccionId]);

            if (existES.rows.length === 0) {
              await client.query(`
                INSERT INTO "Estudiante_Seccion" ("Id_estudiante", "Id_seccion")
                VALUES ($1, $2)
              `, [estudianteId, secInfo.seccionId]);
            }

            // Insertar o actualizar nota en Carga_Nota
            const existNota = await client.query(`
              SELECT "Id_nota" FROM "Carga_Nota"
              WHERE "Id_estudiante" = $1 AND "Id_estructura_evaluacion" = $2
            `, [estudianteId, secInfo.estructuraId]);

            if (existNota.rows.length === 0) {
              await client.query(`
                INSERT INTO "Carga_Nota" ("puntaje", "esta_formalizada", "Id_estudiante", "Id_estructura_evaluacion")
                VALUES ($1, true, $2, $3)
              `, [notaVal, estudianteId, secInfo.estructuraId]);
            } else {
              await client.query(`
                UPDATE "Carga_Nota"
                SET "puntaje" = $1, "esta_formalizada" = true
                WHERE "Id_nota" = $2
              `, [notaVal, existNota.rows[0].Id_nota]);
            }

            totalNotasCargadas++;
          }
        }
      }
    }

    // 5. Habilitar Boletín para todos los estudiantes con notas
    for (const sId of boletinesHabilitados) {
      await client.query(`
        INSERT INTO "Boletin_Estudiante" ("student_id", "academic_year_id", "is_available")
        VALUES ($1, $2, true)
        ON CONFLICT ("student_id", "academic_year_id")
        DO UPDATE SET "is_available" = true, "updated_at" = CURRENT_TIMESTAMP
      `, [sId, anoId]);
    }

    await client.query("COMMIT");
    console.log(`\n🎉 ¡Notas cargadas exitosamente!`);
    console.log(`   📝 Total notas registradas/actualizadas: ${totalNotasCargadas}`);
    console.log(`   📄 Boletines habilitados para ${boletinesHabilitados.size} estudiantes.`);

    return {
      success: true,
      totalNotas: totalNotasCargadas,
      totalEstudiantes: boletinesHabilitados.size
    };
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("❌ Error cargando notas:", error);
    throw error;
  } finally {
    client.release();
  }
}

// Ejecución directa si es llamado desde consola
if (process.argv[1]?.includes("seed_notas_oficiales.js")) {
  seedNotasOficiales()
    .then(() => {
      console.log("🏁 Proceso finalizado.");
      process.exit(0);
    })
    .catch((err) => {
      console.error(err);
      process.exit(1);
    });
}
