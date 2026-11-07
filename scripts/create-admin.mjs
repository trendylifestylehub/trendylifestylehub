// Run with Node.js 20+: node scripts/create-admin.mjs admin@example.com 'A-long-unique-password'
import {webcrypto, randomUUID} from 'node:crypto';
const [email,password]=process.argv.slice(2);
if(!email||!/^\S+@\S+\.\S+$/.test(email)||!password||password.length<14) throw new Error('Supply a valid email and password (minimum 14 characters).');
const enc=s=>new TextEncoder().encode(s);
const b64=b=>Buffer.from(b).toString('base64url');
const salt=b64(webcrypto.getRandomValues(new Uint8Array(16)));
const key=await webcrypto.subtle.importKey('raw',enc(password),'PBKDF2',false,['deriveBits']);
const bits=await webcrypto.subtle.deriveBits({name:'PBKDF2',salt:enc(salt),iterations:210000,hash:'SHA-256'},key,256);
console.log(JSON.stringify({email:email.toLowerCase(),password_hash:salt+'$'+b64(bits)}));
const sqlValue=v=>String(v).replaceAll("'","''");
console.log('Run this SQL in your D1 database:');
console.log("INSERT INTO admins(id,email,password_hash) VALUES('"+randomUUID()+"','"+sqlValue(email.toLowerCase())+"','"+sqlValue(salt+'$'+b64(bits))+"');");
