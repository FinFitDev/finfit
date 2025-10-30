declare namespace Express {
  export interface Request {
    userId?: any; // or type the token payload if you know the schema
  }
}
