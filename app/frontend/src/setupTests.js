// jest-dom adds custom jest matchers for asserting on DOM nodes.
// allows you to do things like:
// expect(element).toHaveTextContent(/react/i)
// learn more: https://github.com/testing-library/jest-dom
import '@testing-library/jest-dom';

// Mock fetch globally so App and other components don't call real APIs in tests
const mockFetch = jest.fn(() =>
  Promise.resolve({
    ok: true,
    status: 200,
    json: () => Promise.resolve({ success: false, data: null }),
    text: () => Promise.resolve(''),
  })
);
global.fetch = mockFetch;
if (typeof window !== 'undefined') window.fetch = mockFetch;
