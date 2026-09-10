// app.js - VERSIÓN CORREGIDA
import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import userRoutes from "./routes/user.routes.js";
import teacherRoutes from "./routes/teacher.routes.js";
import configRoutes from "./routes/config.routes.js";
import studentRoutes from "./routes/student.routes.js";
import notaRoutes from "./routes/nota.routes.js";
import boletinRoutes from "./routes/boletin.routes.js";
import scheduleRoutes from './routes/schedule.routes.js';
import representanteRoutes from './routes/representante.routes.js';
import gradesRoutes from './routes/grades.routes.js';
import inscripcionRepresentanteRoutes from './routes/inscripcionRepresentante.routes.js';
import revisionRoutes from './routes/revision.routes.js';
import promocionRoutes from './routes/promocion.routes.js';

import attendanceRoutes from './routes/attendance.routes.js';

// IMPORTAR MIDDLEWARES DE PROTECCIÓN
import { routeGuard } from "./middlewares/routeGuard.middleware.js";

dotenv.config();

const app = express();

// ============================================
// CONFIGURACIÓN DE CORS
// ============================================
const allowedOrigins = [
  process.env.FRONTEND_URL,
  "https://endanzatachira.org.ve",
  "https://registro.endanzatachira.org.ve",
  "http://localhost:5173",
  "http://localhost:3000"
].filter(Boolean);

const corsOptions = {
  origin: function (origin, callback) {
    // Permitir peticiones sin origin (como Postman, curl, apps móviles)
    if (!origin) return callback(null, true);

    const isExplicitlyAllowed = allowedOrigins.includes(origin);
    const isEndanzaDomain = /^https?:\/\/([a-zA-Z0-9-]+\.)*endanzatachira\.org\.ve(:[0-9]+)?$/.test(origin);
    const isNetlifyDomain = /^https?:\/\/([a-zA-Z0-9-]+\.)*netlify\.app(:[0-9]+)?$/.test(origin);
    const isLocalhost = /^https?:\/\/localhost(:[0-9]+)?$/.test(origin);

    if (isExplicitlyAllowed || isEndanzaDomain || isNetlifyDomain || isLocalhost) {
      return callback(null, true);
    }

    console.warn(`⚠️ CORS bloqueado para origen no autorizado: ${origin}`);
    return callback(null, false);
  },
  credentials: true,
  methods: ["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization", "X-Requested-With", "Accept"],
  optionsSuccessStatus: 200,
};

app.use(cors(corsOptions));

// ============================================
// MIDDLEWARES BÁSICOS - ¡IMPORTANTE: DEBEN IR PRIMERO!
// ============================================
app.use(express.json()); // ← ESTO ES CRUCIAL PARA QUE EL BODY LLEGUE
app.use(express.urlencoded({ extended: true }));

// ============================================
// LOGGING DE PETICIONES
// ============================================
app.use((req, res, next) => {
  console.log(`🌐 ${req.method} ${req.path} - ${new Date().toISOString()}`);
  next();
});

// ============================================
// RUTAS PÚBLICAS (NO REQUIEREN AUTENTICACIÓN)
// ============================================
app.get("/api/health", (req, res) => {
  res.json({
    ok: true,
    message: "API is running",
    timestamp: new Date().toISOString(),
    version: "1.0.0",
    environment: process.env.NODE_ENV || "development",
    security: {
      jwtProtection: "Activo",
      roleProtection: "Activo",
      routeGuard: "Activo"
    }
  });
});

app.get("/", (req, res) => {
  res.json({
    ok: true,
    message: "Bienvenido a la API de Gescol",
    endpoints: {
      auth: "/api/users",
      teachers: "/api/teachers",
      config: "/api/config",
      students: "/api/students",
      notas: "/api/notas",
      boletines: "/api/boletines",
      schedules: "/api/sections, /api/classrooms, /api/days, /api/blocks", // ← TODO en scheduleRoutes
      health: "/api/health",
      verify: "/api/verify-permission"
    },
    version: "1.0.0",
  });
});

// Ruta de utilidad para el frontend
app.get("/api/verify-permission", (req, res) => {
  res.json({
    ok: true,
    message: "Sistema de protección de rutas activo",
    features: {
      jwtAuthentication: true,
      roleBasedAuthorization: true,
      routeGuardMiddleware: true,
      autoRoleVerification: true
    },
    timestamp: new Date().toISOString()
  });
});

// ============================================
// MIDDLEWARE DE PROTECCIÓN GLOBAL DE RUTAS
// ============================================
app.use(routeGuard());

// ============================================
// RUTAS PROTEGIDAS - UNA SOLA VEZ CADA UNA
// ============================================
app.use("/api/users", userRoutes);
app.use("/api/teachers", teacherRoutes);
app.use("/api/config", configRoutes);
app.use("/api/students", studentRoutes);
app.use("/api/notas", notaRoutes);
app.use("/api/boletines", boletinRoutes);
app.use('/api', scheduleRoutes); // ← ESTO YA INCLUYE /sections, /classrooms, /days, /blocks
app.use('/api/representantes', representanteRoutes);
app.use('/api', gradesRoutes);
app.use('/api/inscripciones', inscripcionRepresentanteRoutes);


app.use('/api/attendance', attendanceRoutes);
app.use('/api/revisiones', revisionRoutes);
app.use('/api/promocion', promocionRoutes);

// ============================================
// MIDDLEWARE PARA RUTAS NO ENCONTRADAS
// ============================================
app.use((req, res) => {
  console.warn(`⚠️ Ruta no encontrada: ${req.method} ${req.path}`);

  res.status(404).json({
    ok: false,
    msg: "Route not found",
    path: req.path,
    method: req.method,
    availableEndpoints: {
      auth: "/api/users",
      teachers: "/api/teachers",
      config: "/api/config",
      students: "/api/students",
      notas: "/api/notas",
      boletines: "/api/boletines",
      schedules: "/api/sections, /api/classrooms, /api/days, /api/blocks",
      health: "/api/health",
      verify: "/api/verify-permission"
    },
    suggestion: "Verifica que la ruta sea correcta o que tengas permisos para acceder"
  });
});

// ============================================
// MIDDLEWARE DE MANEJO DE ERRORES GLOBAL
// ============================================
app.use((error, req, res, next) => {
  console.error("🔥 Error global:", error.message);

  const statusCode = error.status || 500;
  const message = error.message || "Internal server error";

  res.status(statusCode).json({
    ok: false,
    msg: message,
    error: process.env.NODE_ENV === "development" ? {
      message: error.message,
      stack: error.stack
    } : undefined,
  });
});

export default app;