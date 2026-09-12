/**
 * Formatea una cadena de texto para que cada palabra inicie con mayúscula y el resto en minúscula.
 * Ejemplo: "ariadna valentina MEJIAS ruiz" -> "Ariadna Valentina Mejias Ruiz"
 * @param {string} str
 * @returns {string}
 */
export const capitalizeWords = (str) => {
  if (!str || typeof str !== 'string') return str || '';
  return str
    .trim()
    .toLowerCase()
    .split(/\s+/)
    .map(word => (word ? word.charAt(0).toUpperCase() + word.slice(1) : ''))
    .join(' ');
};
