import 'dotenv/config';
import { get } from 'env-var';

export const envs = {
    PORT: get('PORT').default('3000').required().asPortNumber(),
    DB_HOST: get('DB_HOST').default('localhost').required().asString(),
    DB_USER: get('DB_USER').default('root').required().asString(),
    DB_PASSWORD: get('DB_PASSWORD').default('').required().asString(),
    DB_NAME: get('DB_NAME').default('gestor_proyectos').required().asString(),

    JWT_SECRET: get('JWT_SECRET').required().asString(),
    JWT_EXPIRATION: get('JWT_EXPIRATION').default('1h').required().asString(),
}