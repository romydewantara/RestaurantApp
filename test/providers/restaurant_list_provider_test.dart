import 'package:mocktail/mocktail.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';
import 'package:test/test.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late ApiService apiService;
  late RestaurantListProvider restaurantListProvider;

  setUp(() {
    apiService = MockApiService();
    restaurantListProvider = RestaurantListProvider(apiService);
  });

  group("restaurant list unit test", () {
    test(
      'Should return RestaurantListNoneState as initial resultState of provider.',
      () {
        final initState = restaurantListProvider.resultState;
        expect(initState, isA<RestaurantListNoneState>());
      },
    );

    test(
      'Should return RestaurantListLoadingState type when fetching data starts.',
      () async {
        final mockRestaurantListResponse = RestaurantListResponse(
          error: false,
          message: 'success',
          count: 0,
          restaurants: [],
        );

        when(
          () => apiService.getRestaurantList(),
        ).thenAnswer((_) async => mockRestaurantListResponse);

        restaurantListProvider.fetchRestaurantList();

        expect(
          restaurantListProvider.resultState,
          isA<RestaurantListLoadingState>(),
        );
      },
    );

    test(
      'Should return RestaurantListLoadedState type when successfully.',
      () async {
        final mockRestaurantListResponse = RestaurantListResponse(
          error: false,
          message: 'success',
          count: 0,
          restaurants: [],
        );

        when(
          () => apiService.getRestaurantList(),
        ).thenAnswer((_) async => mockRestaurantListResponse);

        await restaurantListProvider.fetchRestaurantList();

        final state = restaurantListProvider.resultState;
        expect(state, isA<RestaurantListLoadedState>());
      },
    );

    test(
      'Should return RestaurantListLoadedState with restaurant data when API call is successful.',
      () async {
        final mockRestaurants = [
          Restaurant(
            id: "rqdv5juczeskfw1e867",
            name: "Melting Pot",
            description:
                "Lorem ipsum dolor sit amet, consectetuer adipiscing elit…",
            pictureId: "14",
            city: "Medan",
            rating: 4.2,
          ),
        ];

        final mockRestaurantListResponse = RestaurantListResponse(
          error: false,
          message: 'success',
          count: mockRestaurants.length,
          restaurants: mockRestaurants,
        );

        when(
          () => apiService.getRestaurantList(),
        ).thenAnswer((_) async => mockRestaurantListResponse);

        await restaurantListProvider.fetchRestaurantList();

        final state = restaurantListProvider.resultState;
        expect(state, isA<RestaurantListLoadedState>());

        if (state is RestaurantListLoadedState) {
          expect(state.data, mockRestaurants);
          expect(state.data.length, 1);
          expect(state.data[0].name, "Melting Pot");
          expect(state.data[0].city, "Medan");
          expect(state.data[0].rating, 4.2);
        }
      },
    );

    test('Should return RestaurantListErrorState type when failure.', () async {
      final mockRestaurantListResponse = RestaurantListResponse(
        error: true,
        message: 'Not Found',
        count: 0,
        restaurants: [],
      );

      when(
        () => apiService.getRestaurantList(),
      ).thenAnswer((_) async => mockRestaurantListResponse);

      await restaurantListProvider.fetchRestaurantList();

      final state = restaurantListProvider.resultState;
      expect(state, isA<RestaurantListErrorState>());
    });

    test(
      'Should return RestaurantListErrorState type when error occurs.',
      () async {
        final errorMessage = "Please check your internet connection.";
        final mockRestaurantListResponse = RestaurantListResponse(
          error: true,
          message: 'Not Found',
          count: 0,
          restaurants: [],
        );

        when(
          () => apiService.getRestaurantList(),
        ).thenAnswer((_) async => mockRestaurantListResponse);

        await restaurantListProvider.fetchRestaurantList();

        final state = restaurantListProvider.resultState;

        expect(state, isA<RestaurantListErrorState>());

        if (state is RestaurantListErrorState) {
          expect(state.error, errorMessage);
        }
      },
    );
  });
}
