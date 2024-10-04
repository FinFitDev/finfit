export class ErrorWithCode extends Error {
  public statusCode;
  public type: string | undefined;
  constructor(message: string, code: number, type?: string) {
    super(message);
    this.statusCode = code;
    this.type = type;
  }
}
