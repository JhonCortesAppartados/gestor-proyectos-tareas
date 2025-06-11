import jwt from "jsonwebtoken";

export const sign = jwt.sign;
export const verify = jwt.verify;