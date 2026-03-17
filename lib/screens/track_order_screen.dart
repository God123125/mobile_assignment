import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:khmer_cultur_app/bases/api_endpoints.dart';
import 'package:khmer_cultur_app/bases/user_session.dart';
import 'package:khmer_cultur_app/models/auth/order_model.dart';
import 'package:khmer_cultur_app/services/order_service.dart';
import 'package:khmer_cultur_app/widgets/bottom_nav.dart';

class TrackOrderScreen extends StatefulWidget {
  final OrderModel order;

  const TrackOrderScreen({super.key, required this.order});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  static const String googleApiKey = "AIzaSyBZdrkectDEjkpexYcGVfuBo60KwtCN1xE";

  GoogleMapController? mapController;
  late LatLng userLocation;
  late LatLng storeLocation;
  final OrderService _orderService = OrderService();
  bool _isLoading = false;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();

    // User Location
    userLocation = LatLng(
      UserSession.getLatitude() ?? 11.5564,
      UserSession.getLongitude() ?? 104.9282,
    );

    // Store Location
    storeLocation = LatLng(
      widget.order.products.isNotEmpty
          ? widget.order.products[0].store.address?.latitude ?? 11.5564
          : 11.5564,
      widget.order.products.isNotEmpty
          ? widget.order.products[0].store.address?.longitude ?? 104.9282
          : 104.9282,
    );

    _createMarkers();

    // Load route
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getDirections();
    });
  }

  void _createMarkers() {
    markers.add(
      Marker(
        markerId: const MarkerId("user"),
        position: userLocation,
        infoWindow: const InfoWindow(title: "Your Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId("store"),
        position: storeLocation,
        infoWindow: InfoWindow(
          title: widget.order.products.isNotEmpty
              ? widget.order.products[0].store.name
              : "Store",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  Future<void> _getDirections() async {
    PolylinePoints polylinePoints = PolylinePoints(apiKey: googleApiKey);

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(userLocation.latitude, userLocation.longitude),
        destination: PointLatLng(
          storeLocation.latitude,
          storeLocation.longitude,
        ),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isEmpty) return;

    List<LatLng> route = result.points
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    setState(() {
      polylines.clear();
      polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          points: route,
          width: 6,
          color: Colors.blue,
        ),
      );
    });

    _zoomToFit();
  }

  void _zoomToFit() {
    if (mapController == null) return;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        userLocation.latitude < storeLocation.latitude
            ? userLocation.latitude
            : storeLocation.latitude,
        userLocation.longitude < storeLocation.longitude
            ? userLocation.longitude
            : storeLocation.longitude,
      ),
      northeast: LatLng(
        userLocation.latitude > storeLocation.latitude
            ? userLocation.latitude
            : storeLocation.latitude,
        userLocation.longitude > storeLocation.longitude
            ? userLocation.longitude
            : storeLocation.longitude,
      ),
    );

    mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: SafeArea(
            child: Column(
              children: [
                // HEADER
                Container(
                  color: Colors.grey.shade200,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Order #${widget.order.id.substring(0, 6)}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // GOOGLE MAP
                Expanded(
                  flex: 2,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: userLocation,
                      zoom: 14,
                    ),
                    markers: markers,
                    polylines: polylines,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                  ),
                ),

                // ORDER DETAILS
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Store Info
                          Row(
                            children: [
                              if (widget.order.storeurl != null)
                                ClipOval(
                                  child: Image.network(
                                    widget.order.storeurl!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.store),
                                  ),
                                ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.order.products.isNotEmpty
                                          ? widget.order.products[0].store.name
                                          : "Store",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Ordered At ${widget.order.createdAt.hour}:${widget.order.createdAt.minute}',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Estimated Delivery Time
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  widget.order.estimatedDeliveryTime ?? "-",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'ESTIMATED DELIVERY TIME',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            child: _buildHorizontalTimeline(),
                          ),
                          // PRODUCT LIST
                          widget.order.products.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text("No products found"),
                                  ),
                                )
                              : Column(
                                  children: widget.order.products.map((
                                    product,
                                  ) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.network(
                                              product.imageUrl,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "\$${product.price.toStringAsFixed(2)} x ${product.qty}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            "\$${(product.price * product.qty).toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),

                          // ORDER SUMMARY
                          _buildOrderSummary(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isLoading &&
                  widget.order.status.toLowerCase() != 'completed' &&
                  widget.order.status.toLowerCase() != 'canceled')
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _confirmOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Confirm Order",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(height: 0), 
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalTimeline() {
    String status = widget.order.status.toLowerCase();
    List<Map<String, dynamic>> steps = [
      {
        "title": "Order received",
        "icon": Icons.check,
        "completed": true,
        "active": false,
      },
      {
        "title": "Preparing food",
        "icon": Icons.restaurant,
        "completed": status != "pending",
        "active": status == "preparing",
      },
      {
        "title": "Out for delivery",
        "icon": Icons.delivery_dining,
        "completed": status == "delivering" || status == "completed",
        "active": status == "delivering",
      },
      {
        "title": "Delivered",
        "icon": Icons.home,
        "completed": status == "completed",
        "active": false,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isEven) {
          // Timeline item
          int stepIndex = index ~/ 2;
          final step = steps[stepIndex];
          final circleColor = step['completed'] || step['active']
              ? Colors.blue
              : Colors.grey.shade400;
          final textColor = step['completed']
              ? Colors.blue
              : Colors.grey.shade600;

          return Column(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor,
                ),
                child: Icon(step['icon'], color: Colors.white, size: 14),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 60, // width of the label
                child: Text(
                  step['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor,
                    fontWeight: step['active']
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          );
        } else {
          // Line between items
          int leftStepIndex = index ~/ 2;
          final leftStep = steps[leftStepIndex];
          final lineColor = leftStep['completed']
              ? Colors.blue
              : Colors.grey.shade300;

          return Expanded(
            child: Container(
              height: 2,
              color: lineColor,
              margin: const EdgeInsets.only(
                bottom: 12,
              ), // align with circle vertically
            ),
          );
        }
      }),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow("Order ID", widget.order.id),
          _buildRow("Status", widget.order.status),
          _buildRow("Payment", widget.order.paymentMethod),
          if (widget.order.remark != null)
            _buildRow("Remark", widget.order.remark!),
          _buildRow("Order Time", "${widget.order.createdAt}"),
          const Divider(),
          _buildRow(
            "Delivery Fee",
            "\$${widget.order.deliveryFee.toStringAsFixed(2)}",
          ),
          _buildRow(
            "Discount",
            "-\$${widget.order.totalDiscount.toStringAsFixed(2)}",
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "\$${widget.order.total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmOrder() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = ApiEndpoints.confirmOrder(widget.order.id);
      final response = await _orderService.patch(
        url,
        body: {'isConfirmOrder': true},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order confirmed successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Notify previous screen to refresh
        Navigator.pop(context, true); // <- pass `true` as refresh flag
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to confirm order: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
