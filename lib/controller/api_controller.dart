import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:zion_shopping_admin/constants/api_const.dart';
import 'package:zion_shopping_admin/model/product.dart';

class ApiController extends GetxController {
  //variables for fetching more products on scroll
  int _pages = 2;
  final int _limits = 20;
  //
  final List<Product> _products = [];
  List<Product> get products => _products;

  ApiController() {
    getPendingProducts(true);
  }

  Future<bool> getPendingProducts(bool isinitcall) async {
    Dio _dio = Dio(
      BaseOptions(
        baseUrl: kbaseUrl,
        connectTimeout: 10000,
        receiveTimeout: 100000,
        headers: {'x-access-token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTcsImlhdCI6MTYzNTc4ODIxNCwiZXhwIjoxNjY3MzI0MjE0fQ.Kfp8iWLaExGaZ7doqJiFd9fL_2GimqUtyaKco4pNUTs'},
        responseType: ResponseType.json,
      ),
    );

    try {
      if (isinitcall) {
        int _page = 1;
        int _limit = 20;
        _pages = 2;
        print('init fetch... page= $_page size = $_limit');
        final response = await _dio.get("/data/products/pending?page=$_page&size=$_limit");
        if (response.statusCode == 200) {
          _products.clear();
          for (int i = 0; i < response.data['rows'].length; i++) {
            _products.add(
              Product(
                id: response.data['rows'][i]['id'],
                isPending: response.data['rows'][i]['isPending'],
                posterId: response.data['rows'][i]['posterId'],
                posterName: response.data['rows'][i]['posterName'],
                posterPhoneNumber: response.data['rows'][i]['posterPhoneNumber'],
                posterProfileAvatar: response.data['rows'][i]['posterProfileAvatar'],
                name: response.data['rows'][i]['name'],
                datePosted: response.data['rows'][i]['datePosted'],
                description: response.data['rows'][i]['description'],
                price: response.data['rows'][i]['price'],
                category: response.data['rows'][i]['category'],
                image: response.data['rows'][i]['image'],
              ),
            );
          }
          update();
          return true;
        } else {
          print('fetching more... page= $_pages limit = $_limits');
          final response = await _dio.get("/data/products?page=$_pages&limit=$_limits");
          print(_products.length);
          if (response.statusCode == 200) {
            if (response.data['results'].isNotEmpty) {
              for (var i = 0; i < response.data['results'].length; i++) {
                _products.add(
                  Product(
                    id: response.data['results'][i]['_id'],
                    isPending: response.data['rows'][i]['isPending'],
                    posterId: response.data['results'][i]['posterId'],
                    posterName: response.data['results'][i]['posterName'],
                    posterPhoneNumber: response.data['results'][i]['posterPhoneNumber'],
                    posterProfileAvatar: response.data['results'][i]['posterProfileAvatar'],
                    name: response.data['results'][i]['name'],
                    datePosted: response.data['results'][i]['datePosted'],
                    description: response.data['results'][i]['description'],
                    price: response.data['results'][i]['price'],
                    category: response.data['results'][i]['category'],
                    image: response.data['results'][i]['productImages'],
                  ),
                );
              }
              _pages = _pages + 1;
              print('next page: $_pages');
              update();
            } else {
              return false;
            }
            return true;
          }
        }
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  Future<bool> approveProduct(int id) async {
    print('approve product called');
    Dio _dio = Dio(
      BaseOptions(
        baseUrl: kbaseUrl,
        connectTimeout: 10000,
        receiveTimeout: 100000,
        headers: {'x-access-token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTcsImlhdCI6MTYzNTc4ODIxNCwiZXhwIjoxNjY3MzI0MjE0fQ.Kfp8iWLaExGaZ7doqJiFd9fL_2GimqUtyaKco4pNUTs'},
        responseType: ResponseType.json,
      ),
    );
    try {
      final response = await _dio.patch("/data/product?id=$id");
      if (response.statusCode == 200) {
        final result = await getPendingProducts(true);
        if (result) {
          print('updated products');
        }
        update();
        return true;
      } else {
        print('some thing went wrong with updating the product');
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }
}
