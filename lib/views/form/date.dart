import 'package:flutter/material.dart';
import 'form.dart';

class DateOpenTrip extends StatefulWidget {
  final DateTime allowedStartDate;
  final DateTime allowedEndDate;
  final int tripID;
  final String namaTrip;
  final String pictureTrip;

  const DateOpenTrip({
    Key? key,
    required this.allowedStartDate,
    required this.allowedEndDate,
    required this.tripID,
    required this.namaTrip,
    required this.pictureTrip,
  }) : super(key: key);

  @override
  State<DateOpenTrip> createState() => _DateOpenTripState();
}

class _DateOpenTripState extends State<DateOpenTrip> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.namaTrip),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.network(
                widget.pictureTrip,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Pilih Tanggal",
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildDateSelector(
              context: context,
              label: "Tanggal Mulai",
              selectedDate: startDate,
              onTap: () async {
                DateTime? selected = await showDatePicker(
                  context: context,
                  initialDate: widget.allowedStartDate,
                  firstDate: widget.allowedStartDate,
                  lastDate: widget.allowedEndDate,
                );
                if (selected != null) {
                  setState(() {
                    startDate = selected;
                    endDate = null;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            _buildDateSelector(
              context: context,
              label: "Tanggal Selesai",
              selectedDate: endDate,
              isDisabled: startDate == null,
              onTap: startDate == null
                  ? null
                  : () async {
                      DateTime? selected = await showDatePicker(
                        context: context,
                        initialDate: startDate!,
                        firstDate: startDate!,
                        lastDate: widget.allowedEndDate,
                      );
                      if (selected != null) {
                        setState(() {
                          endDate = selected;
                        });
                      }
                    },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (startDate == null || endDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Harap pilih tanggal mulai dan selesai."),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservationForm(
                        tripID: widget.tripID,
                        tglStart: startDate!,
                        tglEnd: endDate!,
                        namaTrip: widget.namaTrip,
                        pictureTrip: widget.pictureTrip,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text(
                "Lanjutkan ke Form",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector({
    required BuildContext context,
    required String label,
    DateTime? selectedDate,
    bool isDisabled = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Card(
        elevation: 3,
        shadowColor: Colors.black12,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedDate != null
                        ? selectedDate.toLocal().toString().split(' ')[0]
                        : "Klik untuk memilih tanggal",
                    style: TextStyle(
                      fontSize: 16,
                      color: isDisabled ? Colors.grey : Colors.black,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.calendar_today,
                color: isDisabled ? Colors.grey : Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
