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

const COMPOUND_PREFIXES = ['de', 'del', 'la', 'las', 'los', 'san', 'santa'];

/**
 * Obtiene la primera palabra o apellido compuesto (ej: "De Los Angeles", "Del Valle").
 * @param {string} str
 * @returns {string}
 */
export const getFirstWordOrCompound = (str) => {
  if (!str) return '';
  const words = String(str).trim().split(/\s+/).filter(Boolean);
  if (words.length === 0) return '';
  if (words.length === 1) return capitalizeWords(words[0]);

  const firstLower = words[0].toLowerCase();
  if (firstLower === 'de' && words.length > 2) {
    const secondLower = words[1].toLowerCase();
    if (['la', 'las', 'los'].includes(secondLower)) {
      return capitalizeWords(`${words[0]} ${words[1]} ${words[2]}`);
    }
    return capitalizeWords(`${words[0]} ${words[1]}`);
  }
  if (COMPOUND_PREFIXES.includes(firstLower) && words.length > 1) {
    return capitalizeWords(`${words[0]} ${words[1]}`);
  }

  return capitalizeWords(words[0]);
};

/**
 * Formatea para mostrar solo el Primer Nombre y Primer Apellido en listas y tablas.
 * En la ficha o detalle se debe seguir mostrando el nombre completo.
 * Ejemplo:
 *   formatShortName("LEONARDO ANTONIO", "ABREU ROMERO") -> "Leonardo Abreu"
 *   formatShortName("MARIETH FERNANDA", "DE LOS ANGELES") -> "Marieth De Los Angeles"
 *   formatShortName("LEONARDO ANTONIO ABREU ROMERO") -> "Leonardo Abreu"
 * @param {string} firstName - Primer nombre o nombre completo
 * @param {string} [lastName] - Apellidos (opcional)
 * @returns {string}
 */
export const formatShortName = (firstName, lastName = '') => {
  if (!firstName && !lastName) return '';

  if (lastName) {
    const fName = getFirstWordOrCompound(firstName);
    const lName = getFirstWordOrCompound(lastName);
    return `${fName} ${lName}`.trim();
  }

  const words = String(firstName).trim().split(/\s+/).filter(Boolean);
  if (words.length <= 1) return capitalizeWords(words[0] || '');
  if (words.length === 2) return capitalizeWords(`${words[0]} ${words[1]}`);

  if (words.length >= 4) {
    const fName = words[0];
    const rest = words.slice(2).join(' ');
    const lName = getFirstWordOrCompound(rest);
    return capitalizeWords(`${fName} ${lName}`);
  }

  return capitalizeWords(`${words[0]} ${words[2]}`);
};

