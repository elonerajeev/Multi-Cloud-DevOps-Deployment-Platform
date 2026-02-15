/**
 * Must be imported first in test files so fetch is mocked before App (or any component that uses fetch) loads.
 * Uses plain functions so it works in all Jest/Node environments.
 */
const mockResponse = {
  ok: true,
  status: 200,
  json: () => Promise.resolve({ success: false, data: null }),
  text: () => Promise.resolve(''),
};
const mockFetch = () => Promise.resolve(mockResponse);
global.fetch = mockFetch;
if (typeof window !== 'undefined') {
  window.fetch = mockFetch;
}
