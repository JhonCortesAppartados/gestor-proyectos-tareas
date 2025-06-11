import { connection_db } from './connection_db';

async function testConnection() {
  try {
    const [rows] = await connection_db.query('SELECT 1 + 1 AS result');
    console.log('Conexión exitosa a la base de datos:', rows);
  } catch (error) {
    console.error('Error al conectar a la base de datos:', error);
  }
}

testConnection();