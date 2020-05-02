import 'package:flutter/material.dart';

const Color red = Colors.red;
const Color green = Colors.green;
const Color black = Colors.black;
const Color blue = Colors.blue;
const Color amber = Colors.amber;
const Color white = Colors.white;
const Color purple = Colors.purple;
const Color pink = Colors.pink;
const Color grey = Colors.grey;
Color pcolor = Color(0xff32cd32);

const BASE_URL = "https://farmtaste.herokuapp.com";
//list of endpoints:

//I) no Authorization=>https://farmtaste.herokuapp.com/signup

const OTP = BASE_URL +
    "/generate-otp"; //(post request to generate random otp) (body: { mobile_no: string })
const SIGNUP = BASE_URL +
    "/signup"; //(post request to signup or register) (body: { city_id: number, location_id: number, mobile_no: string, otp: number})
const LOGIN = BASE_URL +
    "/login"; //(post request to login) (boy: {mobile_no: string, otp: number})

//II) USER=>

const ME = BASE_URL + "/me"; // (get request to show my details)
//(put request to update my details) (body: {name?: string, email?: string, mobile_no?: string,
//alternate_no?: string, state?: string, city_id?: number, area_id?: number,
//location_id?: number,  pincode?: number, status?: boolean })
// (delete request to soft delete me)

//III) ADDRESS RELATED=>

const ADDRESS = BASE_URL +
    "/address"; // (post req to add city location or area)(for admin) (body: {type: anyOf[city, location, area], title: string,
///city_id?: number(if type location), location_id?: number(if type area)})
const CITIES = BASE_URL + "/cities"; //(get request to see all cities)
const AREA =
    BASE_URL + "/locations/"; //(get request for all locations of a city)
const ALLAREA = BASE_URL +
    "/areas/+locationId"; //(get request for all areas of a particaular location)


// IV) PRODUCT RELATED =>

const GETPRODUCT=BASE_URL+ "/productCategories" ;//(get request to see all categories)
const GETPARTICULARPRODUCATCAT=BASE_URL+ "/productSubCategories/";// (get request to see all sub categories of a particular category)
const GETSUBPRODUCATCAT=BASE_URL+ "/products/";// (get request to see all products of a particular subCategory)


//V) PRODUCT RELATED FOR ADMIN =>

const POSTPRODUCAT=BASE_URL+"/productCategories" ;//(post request to create category) (body: {title: string})
const POSTSUBPRODUCATCAT=BASE_URL+ "/productSubCategories";// (post request to create subCategory  of a category) (body: {title: string, category_id: number, type: "sub category"})
const POSTPRODUCT=BASE_URL+"/products";// (post request to create product of a subcategory) (body: {title: string, sub_category_id: number, type: "product"})

const PUTPRODUCAT=BASE_URL+"/productCategories/+categoryId" ;//(put request to update category) (body: {title: string})
const PUTSUBPRODUCATCAT=BASE_URL+ "/productSubCategories/+subCategoryId";// (put request to update subCategory) (body: {title: string, category_id: number, type: "sub category"})
const PUTPRODUCT=BASE_URL+ "/products/+productId";// (put request to update product) (body: {title: string, sub_category_id: number, type: "product"})

const DELETEPRODUCATCAT=BASE_URL+ "/productCategories/+categoryId" ;// (delete category)
const DELETESUBPRODCAT=BASE_URL+ "/productSubCategories/+subCategoryId" ;// (delete subCategory)
const DELETEPRODUCT=BASE_URL+ "/products/+productId" ;// (delete product)


//CART

const ADDTOCART= BASE_URL+"/add-to-cart"; //(post request to add products to cart) (body: { product_id: number, no_of_units: number })
const MYCART=BASE_URL+ "/my-cart"; //(get request to view products of my cart) 
const UPDATECARTITEM=BASE_URL+ "/cart-item/";// (put request to update no_of_units of cart) (body: { no_of_units: number})
const DELETECARTITEMS =BASE_URL+"/cart-item/";// (delete request to delete an item from my cart)
const EMPTYCART = BASE_URL+ "/empty-cart" ;//(delete request to empty my cart)
