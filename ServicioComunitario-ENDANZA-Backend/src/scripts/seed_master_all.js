// Archivo: backend/src/scripts/seed_master_all.js
import { seedMallaEndanza } from "./seed_malla_endanza.js";
import { seedAulas } from "./seed_aulas.js";
import { seedEstudiantesYRepresentantes } from "./seed_estudiantes_representantes.js";
import { seedNotasOficiales } from "./seed_notas_oficiales.js";

async function runAllSeeds() {
  console.log("===============================================================");
  console.log("🌟 INICIANDO POBLACIÓN MAESTRA DE LA BASE DE DATOS ENDANZA 🌟");
  console.log("===============================================================\n");

  const startTime = Date.now();

  try {
    // 1. Malla Curricular, Especialidades y Grados
    console.log("▶️  [1/4] Población de Malla Curricular...");
    await seedMallaEndanza();
    console.log("✔️  Malla Curricular completada con éxito.\n");

    // 2. Aulas y Ambientes de Aprendizaje
    console.log("▶️  [2/4] Población de Aulas y Ambientes de Aprendizaje...");
    await seedAulas();
    console.log("✔️  Aulas y Ambientes completados con éxito.\n");

    // 3. Estudiantes y Representantes
    console.log("▶️  [3/4] Población de Estudiantes y Representantes...");
    await seedEstudiantesYRepresentantes();
    console.log("✔️  Estudiantes y Representantes completados con éxito.\n");

    // 4. Calificaciones y Boletines Oficiales
    console.log("▶️  [4/4] Población de Calificaciones Oficiales y Boletines...");
    await seedNotasOficiales();
    console.log("✔️  Calificaciones y Boletines completados con éxito.\n");

    const totalSeconds = ((Date.now() - startTime) / 1000).toFixed(2);
    console.log("===============================================================");
    console.log(`🎉 ¡BASE DE DATOS POBLADA AL 100% EN ${totalSeconds} SEGUNDOS! 🎉`);
    console.log("===============================================================");
    process.exit(0);
  } catch (error) {
    console.error("\n❌ Error durante la ejecución de la población maestra:", error);
    process.exit(1);
  }
}

runAllSeeds();
