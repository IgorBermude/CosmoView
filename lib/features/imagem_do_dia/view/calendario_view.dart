import 'package:flutter/material.dart';

import '../../../data/models/apod.dart';
import '../../../data/models/imagem_nasa.dart';
import '../../../data/models/usuario.dart';
import '../repository/nasa_repository.dart';
import '../viewmodel/imagem_viewmodel.dart';

typedef DaySelected = void Function(DateTime date);

class TelaCalendario extends StatefulWidget {
  final Usuario? usuario;
  const TelaCalendario({Key? key, this.usuario}) : super(key: key);

  @override
  _TelaCalendarioState createState() => _TelaCalendarioState();
}

class _TelaCalendarioState extends State<TelaCalendario> {
  final NasaRepository _nasaRepository = NasaRepository();
  final ImagemViewModel _imagemViewModel = ImagemViewModel();
  late DateTime _selectedDate;
  Future<Apod>? _futureApod;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _fetchForDate(_selectedDate);
  }

  String _formatDate(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  void _fetchForDate(DateTime date) {
    final dateStr = _formatDate(date);
    setState(() {
      _futureApod = _nasaRepository.fetchApodByDate(dateStr);
      _liked = false;
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calendário - Imagem do Dia'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                color: Colors.grey[900],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Escolha uma data',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _MonthGrid(
                        selectedDate: _selectedDate,
                        firstAllowed: DateTime(1995, 6, 16),
                        onMonthDaySelected: (d) {
                          _fetchForDate(d);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: _futureApod == null
                  ? const Center(
                      child: Text('Selecione uma data',
                          style: TextStyle(color: Colors.white)))
                  : FutureBuilder<Apod>(
                      future: _futureApod,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Erro ao carregar: ${snapshot.error}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        final apod = snapshot.data!;

                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Data da Imagem',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                apod.date,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[300],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      apod.title,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _liked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color:
                                          _liked ? Colors.red : Colors.grey,
                                    ),
                                    onPressed: () async {
                                      setState(() => _liked = !_liked);

                                      final imagem = ImagemNasa(
                                        titulo: apod.title,
                                        url: apod.url,
                                        explanation: apod.explanation,
                                      );

                                      if (_liked) {
                                        try {
                                          await _imagemViewModel
                                              .adicionarFavorito(
                                                  widget.usuario, imagem);
                                          if (mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Imagem salva como favorita')));
                                          }
                                        } catch (e) {
                                          setState(() => _liked = false);
                                          if (mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Erro ao salvar: $e')));
                                          }
                                        }
                                      } else {
                                        try {
                                          await _imagemViewModel
                                              .removerFavorito(
                                                  widget.usuario, imagem);
                                          if (mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text('Removido dos favoritos')));
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Erro ao remover: $e')));
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              if (apod.isImage)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.blue.shade400, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.6),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2)),
                                    ],
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: AspectRatio(
                                    aspectRatio: 3 / 4,
                                    child: Image.network(
                                      apod.url,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, progress) {
                                        if (progress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: progress
                                                            .expectedTotalBytes !=
                                                        null
                                                ? progress.cumulativeBytesLoaded /
                                                    (progress.expectedTotalBytes ??
                                                        1)
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stack) {
                                        return Container(
                                          color: Colors.grey[800],
                                          child: const Center(
                                            child: Icon(Icons.broken_image,
                                                size: 48, color: Colors.grey),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  height: 220,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.blue.shade400, width: 3),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Conteúdo não é imagem: ${apod.mediaType}',
                                      style:
                                          TextStyle(color: Colors.grey[300]),
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 12),

                              const Text(
                                'Descrição da imagem:',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                apod.explanation,
                                style: TextStyle(color: Colors.grey[300]),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthGrid extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime firstAllowed;
  final DaySelected onMonthDaySelected;

  const _MonthGrid({
    Key? key,
    required this.selectedDate,
    required this.firstAllowed,
    required this.onMonthDaySelected,
  }) : super(key: key);

  @override
  __MonthGridState createState() => __MonthGridState();
}

class __MonthGridState extends State<_MonthGrid> {
  late DateTime _currentMonth;

  final List<String> _weekDays = [
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sáb',
    'Dom'
  ];

  final List<String> _months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];

  @override
  void initState() {
    super.initState();
    _currentMonth =
        DateTime(widget.selectedDate.year, widget.selectedDate.month, 1);
  }

  int _daysInMonth(int year, int month) {
    final firstNext =
        month == 12 ? DateTime(year + 1, 1, 1) : DateTime(year, month + 1, 1);
    return firstNext.subtract(const Duration(days: 1)).day;
  }

  void _prevMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final year = _currentMonth.year;
    final month = _currentMonth.month;
    final daysInMonth = _daysInMonth(year, month);

    final firstWeekday = DateTime(year, month, 1).weekday;
    final offset = firstWeekday - 1;

    final totalCells = offset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: _prevMonth,
                icon: const Icon(Icons.chevron_left, color: Colors.white)),
            Text(
              '${_months[month - 1]} $year',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            IconButton(
                onPressed: _nextMonth,
                icon: const Icon(Icons.chevron_right, color: Colors.white)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _weekDays
              .map((d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style:
                            TextStyle(color: Colors.grey[300], fontSize: 12),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: rows * 7,
          itemBuilder: (context, index) {
            final dayIndex = index - offset + 1;

            if (index < offset || dayIndex > daysInMonth) {
              return Container();
            }

            final date = DateTime(year, month, dayIndex);
            final today = DateTime.now();
            final isDisabled = date.isBefore(widget.firstAllowed) ||
                date.isAfter(
                  DateTime(today.year, today.month, today.day),
                );

            final isSelected =
                date.year == widget.selectedDate.year &&
                date.month == widget.selectedDate.month &&
                date.day == widget.selectedDate.day;

            return GestureDetector(
              onTap: isDisabled
                  ? null
                  : () {
                      widget.onMonthDaySelected(date);
                      setState(() {});
                    },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue.shade400
                      : Colors.grey[850],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: isSelected
                          ? Colors.blueAccent
                          : Colors.grey.shade800),
                ),
                child: Center(
                  child: Text(
                    dayIndex.toString(),
                    style: TextStyle(
                      color: isDisabled
                          ? Colors.grey
                          : (isSelected
                              ? Colors.white
                              : Colors.grey[200]),
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
