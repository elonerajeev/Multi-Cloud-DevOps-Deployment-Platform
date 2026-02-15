// const mongoose = require("mongoose")

// async function connectDB() {
//   try {
//     await mongoose.connect(process.env.Local_MONGODB_URI, {
//         useNewUrlParser: true,
//         useUnifiedTopology: true,
//     });
//     console.log("DB connected via connectDB function");
//   } catch (err) {
//     console.log("Error in connectDB:", err);
//   }
// }

// module.exports = connectDB

const mongoose = require("mongoose");

async function connectDB() {
  try {
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log("DB connected via connectDB function");
  } catch (err) {
    console.log("Error in connectDB:", err);
  }
}

module.exports = connectDB;
