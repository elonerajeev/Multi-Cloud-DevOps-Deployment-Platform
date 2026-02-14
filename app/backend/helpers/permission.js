const userModel = require("../models/userModel")

const uploadProductPermission = async(userId) => {
    const user = await userModel.findById(userId)

    if(user.role === 'ADMIN'){
        return true
    }
    
    //NEW MEMBER 
    // else if(user.role === 'TEST'){
    //     return true
    // }

    return false
}


module.exports = uploadProductPermission
