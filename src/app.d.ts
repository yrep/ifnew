// src/app.d.ts

declare global {

  function dlog(group: string, message: string, data?: Record<string, any>): void;
  
  namespace App {
    // interface Error {}
    // interface Locals {}
    // interface PageData {}
    // interface PageState {}
    // interface Platform {}
  }
}

export {};