import { db } from './src/db/connection.database.js';

async function main() {
  try {
    const colsEF = await db.query("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'estudiante_familiar'");
    console.log('estudiante_familiar columns:');
    console.table(colsEF.rows);

    const colsRep = await db.query("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'representante'");
    console.log('representante columns:');
    console.table(colsRep.rows);

    const colsPersona = await db.query("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'persona'");
    console.log('persona columns:');
    console.table(colsPersona.rows);

    // Let's see Emily's familiares and representante in DB
    const emily = await db.query(`
      SELECT e.id_estudiante, e.id_representante, r.id_persona as rep_id_persona, r.profesion as rep_profesion,
             r.direccion_trabajo, r.telefono_trabajo
      FROM estudiante e
      LEFT JOIN representante r ON e.id_representante = r.id_representante
      WHERE e.id_estudiante = 5
    `);
    console.log('Emily student row:', emily.rows);

    const emilyFam = await db.query(`
      SELECT ef.*, p.nombre, p.apellido, p.ocupacion as p_ocupacion, p.numero_telefono, p.email
      FROM estudiante_familiar ef
      JOIN persona p ON ef.id_persona = p.id_persona
      WHERE ef.id_estudiante = 5
    `);
    console.log('Emily familiares:');
    console.table(emilyFam.rows);

  } catch (err) {
    console.error(err);
  } finally {
    process.exit(0);
  }
}

main();
