import { db } from "../db/connection.database.js";
import bcryptjs from "bcryptjs";
import { capitalizeWords } from "../utils/formatters.js";

export const RepresentanteModel = {
  // Crear representante con usuario simplificado (NewEndanza)
  create: async (data) => {
    let {
      dni,
      first_name,
      last_name,
      phone,
      email,
      parentesco,
      parentesco_otro,
      direccion,
      password,
    } = data;

    first_name = capitalizeWords(first_name);
    last_name = capitalizeWords(last_name);

    try {
      const salt = await bcryptjs.genSalt(10);
      const hashedPassword = await bcryptjs.hash(password, salt);

      await db.query("BEGIN");

      // 1. Insertar o buscar persona del representante
      let personaId;
      const existingPersona = await db.query(
        "SELECT id_persona FROM persona WHERE cedula = $1",
        [dni]
      );

      let repGenero = null;
      if (parentesco === "Madre") repGenero = "femenino";
      else if (parentesco === "Padre") repGenero = "masculino";

      if (existingPersona.rows.length > 0) {
        personaId = existingPersona.rows[0].id_persona;
        await db.query(
          `UPDATE persona 
           SET nombre = $1, apellido = $2, numero_telefono = COALESCE($3, numero_telefono), email = COALESCE($4, email),
               genero = COALESCE($5, genero)
           WHERE id_persona = $6`,
          [first_name, last_name, phone || null, email, repGenero, personaId]
        );
      } else {
        const personaRes = await db.query(
          `INSERT INTO persona (nombre, apellido, cedula, numero_telefono, email, genero)
           VALUES ($1, $2, $3, $4, $5, $6)
           RETURNING id_persona`,
          [first_name, last_name, dni, phone || null, email, repGenero]
        );
        personaId = personaRes.rows[0].id_persona;
      }

      // 2. Dirección (si se suministra)
      let direccionId = null;
      if (direccion && direccion.trim() !== "") {
        const dirRes = await db.query(
          `INSERT INTO direccion (direccion) VALUES ($1) RETURNING id_direccion`,
          [direccion.trim()]
        );
        direccionId = dirRes.rows[0].id_direccion;
      }

      // 3. Crear Usuario (id_rol = 4 para representante)
      let usuarioId;
      const existingUser = await db.query(
        "SELECT id_usuario FROM usuario WHERE id_persona = $1",
        [personaId]
      );

      if (existingUser.rows.length > 0) {
        usuarioId = existingUser.rows[0].id_usuario;
        await db.query(
          `UPDATE usuario SET contrasena = $1, estado_usuario = 'activo' WHERE id_usuario = $2`,
          [hashedPassword, usuarioId]
        );
      } else {
        const userRes = await db.query(
          `INSERT INTO usuario (contrasena, estado_usuario, id_rol, id_direccion, id_persona)
           VALUES ($1, 'activo', 4, $2, $3)
           RETURNING id_usuario`,
          [hashedPassword, direccionId, personaId]
        );
        usuarioId = userRes.rows[0].id_usuario;
      }

      // 4. Asignar rol 4 en usuario_rol
      await db.query(
        `INSERT INTO usuario_rol (id_usuario, id_rol)
         VALUES ($1, 4)
         ON CONFLICT (id_usuario, id_rol) DO NOTHING`,
        [usuarioId]
      );

      // 5. Crear o actualizar registro en tabla representante
      let representanteId;
      const existingRep = await db.query(
        "SELECT id_representante FROM representante WHERE id_persona = $1",
        [personaId]
      );

      if (existingRep.rows.length > 0) {
        representanteId = existingRep.rows[0].id_representante;
        await db.query(
          "UPDATE representante SET id_usuario = $1 WHERE id_representante = $2",
          [usuarioId, representanteId]
        );
      } else {
        const repRes = await db.query(
          `INSERT INTO representante (id_persona, id_usuario, direccion_trabajo)
           VALUES ($1, $2, $3)
           RETURNING id_representante`,
          [personaId, usuarioId, direccion || null]
        );
        representanteId = repRes.rows[0].id_representante;
      }

      await db.query("COMMIT");

      return {
        id_representante: representanteId,
        id_usuario: usuarioId,
        id_persona: personaId,
        dni,
        first_name,
        last_name,
        phone,
        email,
        parentesco,
        parentesco_otro,
        plainPassword: password,
      };
    } catch (error) {
      await db.query("ROLLBACK");
      console.error("❌ Error creando representante en NewEndanza:", error);
      throw error;
    }
  },

  // Vincular usuario existente (ej. Docente) como Representante
  linkExistingUserAsRepresentante: async (usuarioId, data = {}) => {
    try {
      await db.query("BEGIN");

      // 1. Obtener id_persona del usuario
      const userRes = await db.query(
        `SELECT u.id_usuario, u.id_persona, p.cedula as dni, p.nombre as first_name, p.apellido as last_name, p.email, p.numero_telefono as phone
         FROM usuario u
         JOIN persona p ON u.id_persona = p.id_persona
         WHERE u.id_usuario = $1`,
        [usuarioId]
      );

      if (userRes.rows.length === 0) {
        throw new Error("Usuario no encontrado");
      }

      const u = userRes.rows[0];
      const personaId = u.id_persona;

      // 2. Verificar si ya existe en tabla representante
      let repRes = await db.query(
        "SELECT id_representante as id FROM representante WHERE id_persona = $1",
        [personaId]
      );

      let repId;
      if (repRes.rows.length === 0) {
        const insertRep = await db.query(
          `INSERT INTO representante (id_persona, id_usuario, direccion_trabajo)
           VALUES ($1, $2, $3)
           RETURNING id_representante as id`,
          [personaId, usuarioId, data.direccion || null]
        );
        repId = insertRep.rows[0].id;
      } else {
        repId = repRes.rows[0].id;
        await db.query(
          "UPDATE representante SET id_usuario = $1 WHERE id_representante = $2",
          [usuarioId, repId]
        );
      }

      // 3. Asignar rol 4 en usuario_rol
      await db.query(
        `INSERT INTO usuario_rol (id_usuario, id_rol)
         VALUES ($1, 4)
         ON CONFLICT (id_usuario, id_rol) DO NOTHING`,
        [usuarioId]
      );

      await db.query("COMMIT");

      return {
        id_representante: repId,
        id_usuario: usuarioId,
        id_persona: personaId,
        dni: u.dni,
        first_name: u.first_name,
        last_name: u.last_name,
        email: u.email,
        phone: u.phone,
        parentesco: data.parentesco || "Familiar",
        parentesco_otro: data.parentesco_otro || null,
        isExistingDocente: true,
      };
    } catch (error) {
      await db.query("ROLLBACK");
      console.error("❌ Error en linkExistingUserAsRepresentante:", error);
      throw error;
    }
  },

  // Buscar representante por cédula
  findByCedula: async (cedula) => {
    try {
      const query = {
        text: `
          SELECT 
            u.id_usuario,
            r.id_representante,
            r.id_persona,
            p.cedula as dni,
            p.nombre as first_name,
            p.apellido as last_name,
            p.numero_telefono as phone,
            p.email,
            r.profesion as profesion_rep,
            r.direccion_trabajo as direccion,
            u.estado_usuario as status
          FROM representante r
          JOIN persona p ON r.id_persona = p.id_persona
          LEFT JOIN usuario u ON r.id_usuario = u.id_usuario
          WHERE p.cedula = $1
        `,
        values: [cedula],
      };

      const { rows } = await db.query(query.text, query.values);
      if (rows.length === 0) return null;

      const row = rows[0];
      return {
        id_representante: row.id_representante,
        id_usuario: row.id_usuario,
        id_persona: row.id_persona,
        dni: row.dni,
        first_name: row.first_name,
        last_name: row.last_name,
        phone: row.phone,
        email: row.email,
        parentesco: "Familiar",
        direccion: row.direccion,
        status: row.status,
      };
    } catch (error) {
      console.error("Error en findByCedula:", error);
      throw error;
    }
  },

  // Buscar por email
  findByEmail: async (email) => {
    try {
      const query = {
        text: `
          SELECT 
            u.id_usuario,
            r.id_representante,
            r.id_persona,
            p.cedula as dni,
            p.nombre as first_name,
            p.apellido as last_name,
            p.numero_telefono as phone,
            p.email
          FROM representante r
          JOIN persona p ON r.id_persona = p.id_persona
          LEFT JOIN usuario u ON r.id_usuario = u.id_usuario
          WHERE p.email = $1
        `,
        values: [email],
      };

      const { rows } = await db.query(query.text, query.values);
      if (rows.length === 0) return null;

      const row = rows[0];
      return {
        ...row,
        parentesco: "Familiar",
      };
    } catch (error) {
      console.error("Error en findByEmail:", error);
      throw error;
    }
  },

  // Buscar representantes por término
  search: async (term) => {
    try {
      const query = {
        text: `
          SELECT 
            u.id_usuario,
            r.id_representante,
            r.id_persona,
            p.cedula as dni,
            p.nombre as first_name,
            p.apellido as last_name,
            p.numero_telefono as phone,
            p.email
          FROM representante r
          JOIN persona p ON r.id_persona = p.id_persona
          LEFT JOIN usuario u ON r.id_usuario = u.id_usuario
          WHERE (
            p.nombre ILIKE $1 OR
            p.apellido ILIKE $1 OR
            p.cedula ILIKE $1 OR
            p.email ILIKE $1
          )
          ORDER BY p.apellido, p.nombre
          LIMIT 20
        `,
        values: [`%${term}%`],
      };

      const { rows } = await db.query(query.text, query.values);
      return rows;
    } catch (error) {
      console.error("Error en search:", error);
      throw error;
    }
  },

  // Obtener estudiantes asociados a un representante
  getEstudiantes: async (representanteId) => {
    try {
      const query = {
        text: `
          SELECT 
            e.id_estudiante as id,
            p.nombre as first_name,
            p.apellido as last_name,
            p.cedula as dni,
            p.fecha_nacimiento as birth_date,
            p.genero as gender,
            COALESCE(nd.nivel_danza, 'Sin Asignar') as grade_level,
            nd.nivel_danza as dance_level,
            nd.nivel_danza as dance_level_name,
            nl.nivel as school_grade,
            nl.nivel as regular_grade,
            e.seguro_escolar as school_insurance
          FROM estudiante e
          JOIN persona p ON e.id_persona = p.id_persona
          LEFT JOIN nivel_escolar nl ON e.id_nivel = nl.id_nivel
          LEFT JOIN nivel_danza nd ON e.id_nivel_danza = nd.id_nivel_danza
          WHERE e.id_representante = $1
        `,
        values: [representanteId],
      };

      const { rows } = await db.query(query.text, query.values);
      return rows;
    } catch (error) {
      console.error("Error en getEstudiantes:", error);
      throw error;
    }
  },

  // Buscar representante por ID
  findById: async (id) => {
    try {
      const query = {
        text: `
          SELECT 
            u.id_usuario,
            r.id_representante,
            r.id_persona,
            p.cedula as dni,
            p.nombre as first_name,
            p.apellido as last_name,
            p.numero_telefono as phone,
            p.email,
            r.profesion as profesion_rep,
            r.direccion_trabajo as direccion,
            u.estado_usuario as status
          FROM representante r
          JOIN persona p ON r.id_persona = p.id_persona
          LEFT JOIN usuario u ON r.id_usuario = u.id_usuario
          WHERE r.id_representante = $1
        `,
        values: [id],
      };

      const { rows } = await db.query(query.text, query.values);
      if (rows.length === 0) return null;

      const row = rows[0];
      return {
        ...row,
        parentesco: "Familiar",
      };
    } catch (error) {
      console.error("Error en findById:", error);
      throw error;
    }
  },

  // Listar TODOS los representantes
  list: async () => {
    try {
      const query = {
        text: `
          SELECT 
            u.id_usuario,
            r.id_representante,
            r.id_persona,
            p.cedula as dni,
            p.nombre as first_name,
            p.apellido as last_name,
            p.numero_telefono as phone,
            p.email,
            u.estado_usuario as status
          FROM representante r
          JOIN persona p ON r.id_persona = p.id_persona
          LEFT JOIN usuario u ON r.id_usuario = u.id_usuario
          ORDER BY p.apellido, p.nombre
        `,
      };

      const { rows } = await db.query(query.text);
      return rows;
    } catch (error) {
      console.error("Error en list:", error);
      throw error;
    }
  },

  findByUserId: async (userId) => {
    try {
      const query = {
        text: `
          SELECT 
            r.id_representante as id,
            r.id_representante,
            r.id_usuario as user_id,
            r.id_persona,
            p.nombre,
            p.apellido,
            p.cedula,
            p.email
          FROM representante r
          JOIN persona p ON r.id_persona = p.id_persona
          WHERE r.id_usuario = $1
        `,
        values: [userId],
      };

      const { rows } = await db.query(query.text, query.values);
      if (rows.length > 0) {
        return rows[0];
      }

      // Soporte dual por cédula
      const userRes = await db.query(
        `SELECT p.cedula FROM usuario u JOIN persona p ON u.id_persona = p.id_persona WHERE u.id_usuario = $1`,
        [userId]
      );

      if (userRes.rows.length > 0 && userRes.rows[0].cedula) {
        const cedula = userRes.rows[0].cedula;
        const repByCedula = await db.query(
          `SELECT 
             r.id_representante as id,
             r.id_representante,
             COALESCE(r.id_usuario, $1) as user_id,
             r.id_persona,
             p.nombre,
             p.apellido,
             p.cedula,
             p.email
           FROM representante r
           JOIN persona p ON r.id_persona = p.id_persona
           WHERE p.cedula = $2`,
          [userId, cedula]
        );
        if (repByCedula.rows.length > 0) {
          return repByCedula.rows[0];
        }
      }

      return null;
    } catch (error) {
      console.error("❌ Error en findByUserId:", error);
      throw error;
    }
  },
};