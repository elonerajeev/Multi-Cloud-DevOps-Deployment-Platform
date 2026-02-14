import React from 'react';

const Footer = () => {
  return (
    <footer className='bg-gray-800 text-white py-8'>
      <div className='container mx-auto px-4'>
        <div className='flex flex-col md:flex-row justify-between items-start md:items-center'>
          <div className='mb-8 md:mb-0'>
            <h2 className='text-xl font-bold mb-2'>E-Shop & Elone.rajeev</h2>
            <p className='text-gray-400'>Your one-stop shop for everything you need.</p>
          </div>
          <div className='flex flex-col md:flex-row justify-between items-start md:items-center w-full md:w-auto'>
            <div className='mb-8 md:mb-0 md:mr-8'>
              <h4 className='text-lg font-bold mb-2'>Navigation</h4>
              <ul className='list-none space-y-2'>
                <li><a href='/about' className='text-gray-400 hover:text-white transition duration-300'>About Us</a></li>
                <li><a href='/contact' className='text-gray-400 hover:text-white transition duration-300'>Contact Us</a></li>
                <li><a href='/shop' className='text-gray-400 hover:text-white transition duration-300'>Shop</a></li>
                <li><a href='/faq' className='text-gray-400 hover:text-white transition duration-300'>FAQ</a></li>
              </ul>
            </div>
            <div className='mb-8 md:mb-0 md:mr-8'>
              <h4 className='text-lg font-bold mb-2'>Follow Us</h4>
              <ul className='list-none space-y-2'>
                <li><a href='https://x.com/rajeev02030066' className='text-gray-400 hover:text-white transition duration-300'>Twitter</a></li>
                <li><a href='https://github.com/elonerajeev' className='text-gray-400 hover:text-white transition duration-300'>Github</a></li>
                <li><a href='https://www.linkedin.com/in/rajeev-kumar-2209b1243/' className='text-gray-400 hover:text-white transition duration-300'>LinkedIn</a></li>
              </ul>
            </div>
            <div>
              <h4 className='text-lg font-bold mb-2'>Contact Info</h4>
              <p className='text-gray-400'>Email: <a href='mailto:elonerajeev@eshop.com' className='hover:text-white transition duration-300'>elonerajeev@gmail.com</a></p>
              <p className='text-gray-400'>Phone: <a href='tel:+91 92641XXXXX' className='hover:text-white transition duration-300'>+91 92641XXXXX</a></p>
              <p className='text-gray-400'>Address : indian XXXXX  CO</p>
            </div>
          </div>
        </div>
        <div className='text-center mt-8 border-t border-gray-700 pt-4'>
          <p className='text-gray-400'>&copy; 2024 E-Shop. All rights reserved.</p>
        </div>
      </div>
    </footer>
  );
}

export default Footer;
