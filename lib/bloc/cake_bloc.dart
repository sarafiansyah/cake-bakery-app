import 'package:bloc/bloc.dart';
import 'package:ralali_bakery/bloc/cake_event.dart';
import 'package:ralali_bakery/bloc/cake_state.dart';
import 'package:ralali_bakery/models/cake_model.dart';

class CakeBloc extends Bloc<CakeEvent, CakeState> {
  CakeBloc() : super(CakeInitial());

  @override
  Stream<CakeState> mapEventToState(CakeEvent event) async* {
    if (event is FetchCakes) {
      yield CakeLoading();
      try {
        final List<CakeModel> cakes = await _fetchCakes();
        yield CakeLoaded(cakes: cakes);
      } catch (e) {
        yield CakeError(error: e.toString());
      }
    }
  }

  Future<List<CakeModel>> _fetchCakes() async {
    // Simulate an asynchronous operation
    await Future.delayed(Duration(seconds: 2));

    // Replace this with your actual API call to fetch cakes
    final List<CakeModel> cakes = [
      CakeModel(
        id: '1',
        name: 'Cake 1',
        description: 'Delicious cake 1',
        imageUrl: 'https://example.com/cake1.jpg',
        price: 10.99,
      ),
      CakeModel(
        id: '2',
        name: 'Cake 2',
        description: 'Yummy cake 2',
        imageUrl: 'https://example.com/cake2.jpg',
        price: 12.99,
      ),
      CakeModel(
        id: '3',
        name: 'Cake 3',
        description: 'Tasty cake 3',
        imageUrl: 'https://example.com/cake3.jpg',
        price: 15.99,
      ),
    ];

    return cakes;
  }
}
