import './testMockFetch'; // Must run first so fetch is mocked before App loads
import { render } from '@testing-library/react';
import { Provider } from 'react-redux';
import { MemoryRouter, Routes, Route } from 'react-router-dom';
import App from './App';
import { store } from './store/store';

test('renders app without crashing', () => {
  render(
    <Provider store={store}>
      <MemoryRouter>
        <Routes>
          <Route path="/" element={<App />}>
            <Route index element={<span>Home</span>} />
          </Route>
        </Routes>
      </MemoryRouter>
    </Provider>
  );
  // App has Header/Footer; just assert something rendered (e.g. a link or the main area)
  expect(document.body.textContent).toBeTruthy();
});
