import { db } from './connection.database.js';

async function checkData() {
  try {
    const resEst = await db.query('SELECT count(*) FROM "Estudiante"');
    console.log('CANTIDAD_ESTUDIANTES:', resEst.rows[0].count);
    process.exit(0);
  } catch (err) {
    console.error('ERROR_CHECK:', err.message);
    process.exit(1);
  }
}

checkData();
