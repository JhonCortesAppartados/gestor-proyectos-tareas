import bcrypt from 'bcrypt';

export const hash = bcrypt.hash;
export const compare = bcrypt.compare;