$(document).ready(function(){

	if($("div#contact_map").exists()){
		var myMap;

		function init_contact_map () {
				    // Создание экземпляра карты и его привязка к контейнеру с
				    // заданным id ("map").
				    myMap = new ymaps.Map('contact_map', {
				        // При инициализации карты обязательно нужно указать
				        // её центр и коэффициент масштабирования.
				        center: [55.556196,37.043308], 
				        zoom: 11,
				        controls: ['zoomControl', 'fullscreenControl']
				    });
				      // Создаем геообъект с типом геометрии "Точка".
				        myGeoObject = new ymaps.GeoObject({
				            // Описание геометрии.
				            geometry: {
				                type: "Point",
				                coordinates: [55.551805,36.971436]
				            },
				            // Свойства.
				            properties: {
				                // Контент метки.
				                iconContent: 'Мы здесь',
				            	balloonContentHeader: "Юридический адрес",
					            balloonContentBody: "Московская область,<br>Наро-Фоминский район,<br>пос. Калининец, 264.<br>Телефон: +7(926)927-65-78",
				                balloonContentFooter: 'Скоро мы откроем свой офис.',
				                hintContent: "Кликните для подробностей."
				            }
				        },{
				            // Опции.
				            // Иконка метки будет растягиваться под размер ее содержимого.
				            preset: 'islands#blackStretchyIcon'
				        });
									
				    myMap.geoObjects.add(myGeoObject);
		}	
		ymaps.ready(init_contact_map);
	};

	if($("div#delivery_map").exists()){
		var	myMap,
		// Контейнер для меню
	    menu = $('<table class="default_table" id="delivery_map_menu"/>'),
	    menu_header = $('<tr class="header"><th>Район</th><th>Стоимость доставки</th></tr>');

		menu_header.appendTo(menu);

		function fillOpasity_enter (e) {
			// Ссылку на объект, вызвавший событие,
			// можно получить из поля 'target'.
			e.get('target').options.set('fillOpacity', '0.4');
			};
			
		function fillOpasity_leave (e) {
			e.get('target').options.set('fillOpacity', '0.2');
			};

		function init_delivery_map () {
				    // Создание экземпляра карты и его привязка к контейнеру с
				    // заданным id ("map").
				    myMap = new ymaps.Map('delivery_map', {
				        // При инициализации карты обязательно нужно указать
				        // её центр и коэффициент масштабирования.
				        center: [55.56304,36.985614], 
				        zoom: 12,
				        controls: ['zoomControl', 'fullscreenControl']
				    });
				    
				    //добавляем слои
				    myMap.controls.add(new ymaps.control.TypeSelector(['yandex#map', 'yandex#satellite', 'yandex#hybrid']));
				    
				    // Создаем геообъект с типом геометрии "Точка".
				    myGeoObject = new ymaps.GeoObject({
				            // Описание геометрии.
				            geometry: {
				                type: "Point",
				                coordinates: [55.551805,36.971436]
				            },
				            // Свойства.
				            properties: {
				                // Контент метки.
				                iconContent: 'Мы здесь',
				            	balloonContentHeader: "Юридический адрес",
					            balloonContentBody: "Московская область,<br>Наро-Фоминский район,<br>пос. Калининец, 264.<br>Телефон: +7(926)927-65-78",
				                balloonContentFooter: 'Скоро мы откроем свой офис.',
				                hintContent: "Кликните для подробностей."				            }
				        },{
				            // Опции.
				            // Иконка метки будет растягиваться под размер ее содержимого.
				            preset: 'islands#blackStretchyIcon'
				        });
									
				    myMap.geoObjects.add(myGeoObject);
				    
				    //фрматирование хинта
				   	var MyHintContentLayoutClass = ymaps.templateLayoutFactory.createClass(
					   '<b>Зона $[properties.zone]</b><br/>$[properties.description] <br/> Доставка - $[properties.price] руб.' 
					);
				      // Кэч
					    var myPolygon_1 = new ymaps.Polygon([
					        // Указываем координаты вершин многоугольника.
					        // Координаты вершин внешнего контура.
					        [
							[	55.549223	,	36.97098	]	,
							[	55.549612	,	36.962912	]	,
							[	55.55618	,	36.956732	]	,
							[	55.559221	,	36.963384	]	,
							[	55.563161	,	36.96892	]	,
							[	55.559756	,	36.98188	]	,
							[	55.558297	,	36.990549	]	,
							[	55.549539	,	36.983983	]	

					        ]
					    ], {
					        // Описываем свойства геообъекта.
					        // Содержимое балуна.
					        //hintContent: "КЭЧ, доставка 30 руб.",
					        zone: '1',
					        description: 'КЭЧ',
					        price: '30'
					    }, {
					        // Задаем опции геообъекта.
					        // Цвет заливки.
					        fillColor: '#eb5055',
					        fillOpacity: 0.2,
					        // Ширина обводки.
					        strokeWidth: 5,
					        strokeColor: '#FF0000',
					        hintContentLayout: MyHintContentLayoutClass
					    });
					    // Добавляем многоугольник на карту.
    					myMap.geoObjects.add(myPolygon_1);
    					createMenu(myPolygon_1, menu);
    					
    					//добавляем события
    					myPolygon_1.events.add('mouseenter', function (e){ fillOpasity_enter(e); });
    					myPolygon_1.events.add('mouseleave', function (e){ fillOpasity_leave(e); });
    					
				      // Тарасково
					    var myPolygon_2 = new ymaps.Polygon([
					        // Указываем координаты вершин многоугольника.
					        // Координаты вершин внешнего контура.
					        [
								[	55.558297	,	36.990549	]	,
								[	55.559756	,	36.98188	]	,
								[	55.563161	,	36.96892	]	,
								[	55.579671	,	36.983811	]	,
								[	55.584728	,	37.001836	]	,
								[	55.584242	,	37.02192	]	,
								[	55.570286	,	37.027499	]	,
								[	55.561191	,	37.006213	]	

					        ]
					    ], {
					        // Описываем свойства геообъекта.
					        // Содержимое балуна.
					        //hintContent: "Тарасково, НИИ Радио, доставка 50 руб."
					        zone: '2',
					        description: 'Тарасково, НИИ Радио',
					        price: '50'
					    }, {
					        // Задаем опции геообъекта.
					        // Цвет заливки.
					        fillColor: '#3399FF',
					        fillOpacity: 0.2,
					        // Ширина обводки.
					        strokeWidth: 5,
					        strokeColor: '#FF0000',
					        hintContentLayout: MyHintContentLayoutClass
					    });
					    // Добавляем многоугольник на карту.
    					myMap.geoObjects.add(myPolygon_2);
    					createMenu(myPolygon_2, menu);

    					//добавляем события
    					myPolygon_2.events.add('mouseenter', function (e){ fillOpasity_enter(e); });
    					myPolygon_2.events.add('mouseleave', function (e){ fillOpasity_leave(e); });

				      // Кобяково
					    var myPolygon_3 = new ymaps.Polygon([
					        // Указываем координаты вершин многоугольника.
					        // Координаты вершин внешнего контура.
					        [
								[	55.579671	,	36.983811	]	,
								[	55.598599	,	36.964768	]	,
								[	55.605727	,	37.0256	]	,
								[	55.592022	,	37.0256	]	,
								[	55.584242	,	37.02192	]	,
								[	55.584728	,	37.001836	]	

					        ]
					    ], {
					        // Описываем свойства геообъекта.
					        // Содержимое балуна.
					        //hintContent: "Кобяково, доставка 70 руб."
					        zone: '3',
					        description: 'Кобяково',
					        price: '70'
					    }, 
					    {
					        // Задаем опции геообъекта.
					        // Цвет заливки.
					        fillColor: '#FFFF00',
					        fillOpacity: 0.2,
					        // Ширина обводки.
					        strokeWidth: 5,
					        strokeColor: '#FF0000',
					        hintContentLayout: MyHintContentLayoutClass
					    });
					    // Добавляем многоугольник на карту.
    					myMap.geoObjects.add(myPolygon_3);
    					createMenu(myPolygon_3, menu);

    					//добавляем события
    					myPolygon_3.events.add('mouseenter', function (e){ fillOpasity_enter(e); });
    					myPolygon_3.events.add('mouseleave', function (e){ fillOpasity_leave(e); });
    					
						// Краснознаменск
					    var myPolygon_3_5 = new ymaps.Polygon([
					        // Указываем координаты вершин многоугольника.
					        // Координаты вершин внешнего контура.
					        [
								[	55.605727	,	37.0256	]	,
								[	55.592022	,	37.0256	]	,
								[	55.584242	,	37.02192	]	,
								[	55.570286	,	37.027499	]	,
								[	55.573806	,	37.065705	]	,
								[	55.610649	,	37.066048	]	

					        ]
					    ], {
					        // Описываем свойства геообъекта.
					        // Содержимое балуна.
					        //hintContent: "Краснознаменск, доставка 200 руб."
					        zone: '5',
					        description: 'Краснознаменск',
					        price: '200'
					    }, {
					        // Задаем опции геообъекта.
					        // Цвет заливки.
					        fillColor: '#FF00FF',
					        fillOpacity: 0.2,
					        // Ширина обводки.
					        strokeWidth: 5,
					        strokeColor: '#FF0000',
					        hintContentLayout: MyHintContentLayoutClass
					    });
					    // Добавляем многоугольник на карту.
    					myMap.geoObjects.add(myPolygon_3_5);
    					createMenu(myPolygon_3_5, menu);

    					//добавляем события
    					myPolygon_3_5.events.add('mouseenter', function (e){ fillOpasity_enter(e); });
    					myPolygon_3_5.events.add('mouseleave', function (e){ fillOpasity_leave(e); });
    					
				      // Голицыно
					    var myPolygon_4 = new ymaps.Polygon([
					        // Указываем координаты вершин многоугольника.
					        // Координаты вершин внешнего контура.
					        [
								[	55.598599	,	36.964768	]	,
								[	55.629136	,	36.952236	]	,
								[	55.630205	,	36.966999	]	,
								[	55.629889	,	36.989616	]	,
								[	55.625931	,	36.988242	]	,
								[	55.623212	,	36.985625	]	,
								[	55.621269	,	36.990731	]	,
								[	55.614542	,	37.00867	]	,
								[	55.610649	,	37.066048	]	
					        ]
					    ], {
					        // Описываем свойства геообъекта.
					        // Содержимое балуна.
					        //hintContent: "Голицыно, доставка 100 руб."
					        zone: '4',
					        description: 'Голицыно',
					        price: '100'
					    }, {
					        // Задаем опции геообъекта.
					        // Цвет заливки.
					        fillColor: '#00FF00',
					        fillOpacity: 0.2,
					        // Ширина обводки.
					        strokeWidth: 5,
					        strokeColor: '#FF0000',
					        hintContentLayout: MyHintContentLayoutClass
					    });
					    // Добавляем многоугольник на карту.
    					myMap.geoObjects.add(myPolygon_4);
    					createMenu(myPolygon_4, menu);

    					//добавляем события
    					myPolygon_4.events.add('mouseenter', function (e){ fillOpasity_enter(e); });
    					myPolygon_4.events.add('mouseleave', function (e){ fillOpasity_leave(e); });
    					
				      // Бурцево
					    var myPolygon_5 = new ymaps.Polygon([
					        // Указываем координаты вершин многоугольника.
					        // Координаты вершин внешнего контура.
					        [
								[	55.549539	,	36.983983	]	,
								[	55.549223	,	36.97098	]	,
								[	55.549612	,	36.962912	]	,
								[	55.539283	,	36.966119	]	,
								[	55.531763	,	36.968222	]	,
								[	55.532395	,	36.971012	]	,
								[	55.531397	,	36.980711	]	,
								[	55.530813	,	36.997491	]	,
								[	55.540232	,	37.010923	]	,
								[	55.547581	,	37.001825	]	
					        ]
					    ], {
					        // Описываем свойства геообъекта.
					        // Содержимое балуна.
					        //hintContent: "Бурцево, Петровское, доставка 50 руб."
					        zone: '2',
					        description: 'Бурцево, Петровское',
					        price: '50'
					    }, {
					        // Задаем опции геообъекта.
					        // Цвет заливки.
					        fillColor: '#3399FF',
					        fillOpacity: 0.2,
					        // Ширина обводки.
					        strokeWidth: 5,
					        strokeColor: '#FF0000',
					        hintContentLayout: MyHintContentLayoutClass
					    });
					    // Добавляем многоугольник на карту.
    					myMap.geoObjects.add(myPolygon_5);
    					createMenu(myPolygon_5, menu);

    					//добавляем события
    					myPolygon_5.events.add('mouseenter', function (e){ fillOpasity_enter(e); });
    					myPolygon_5.events.add('mouseleave', function (e){ fillOpasity_leave(e); });
    					
				      // Селятино
					    var myPolygon_6 = new ymaps.Polygon([
					        // Указываем координаты вершин многоугольника.
					        // Координаты вершин внешнего контура.
					        [
								[	55.531763	,	36.968222	]	,
								[	55.532395	,	36.971012	]	,
								[	55.531397	,	36.980711	]	,
								[	55.530813	,	36.997491	]	,
								[	55.523693	,	37.017135	]	,
								[	55.519621	,	37.000859	]	,
								[	55.514343	,	36.992073	]	,
								[	55.506258	,	36.988639	]	,
								[	55.507798	,	36.982599	]	,
								[	55.507798	,	36.973501	]	,
								[	55.510842	,	36.957236	]	,
								[	55.518489	,	36.954489	]	,
								[	55.522299	,	36.951378	]	,
								[	55.531379	,	36.966098	]	
					        ]
					    ], {
					        // Описываем свойства геообъекта.
					        // Содержимое балуна.
					        //hintContent: "Селятино, Фабричная, доставка 70 руб."
					        zone: '3',
					        description: 'Селятино, Алабино',
					        price: '70'
					    }, {
					        // Задаем опции геообъекта.
					        // Цвет заливки.
					        fillColor: '#FFFF00',
					        fillOpacity: 0.2,
					        // Ширина обводки.
					        strokeWidth: 5,
					        strokeColor: '#FF0000',
					        hintContentLayout: MyHintContentLayoutClass
					    });
					    // Добавляем многоугольник на карту.
    					myMap.geoObjects.add(myPolygon_6);
    					createMenu(myPolygon_6, menu);
    					
    					//добавляем события
    					myPolygon_6.events.add('mouseenter', function (e){ fillOpasity_enter(e); });
    					myPolygon_6.events.add('mouseleave', function (e){ fillOpasity_leave(e); });
    					
				      // рассудово
					    var myPolygon_7 = new ymaps.Polygon([
					        // Указываем координаты вершин многоугольника.
					        // Координаты вершин внешнего контура.
					        [
								[	55.510842	,	36.957236	]	,
								[	55.518489	,	36.954489	]	,
								[	55.522299	,	36.951378	]	,
								[	55.527226	,	36.941658	]	,
								[	55.525035	,	36.929384	]	,
								[	55.510036	,	36.924234	]	,
								[	55.49849	,	36.911617	]	,
								[	55.488793	,	36.926895	]	,
								[	55.500683	,	36.939083	]	

					        ]
					    ], {
					        // Описываем свойства геообъекта.
					        // Содержимое балуна.
					        //hintContent: "Зверево, СНТ Весна, доставка 100 руб.",
					        zone: '4',
					        description: 'Зверево, СНТ Весна',
					        price: '100'
					    }, {
					        // Задаем опции геообъекта.
					        // Цвет заливки.
					        fillColor: '#00FF00',
					        fillOpacity: 0.2,
					        // Ширина обводки.
					        strokeWidth: 5,
					        strokeColor: '#FF0000',
					        hintContentLayout: MyHintContentLayoutClass
					    });
					    // Добавляем многоугольник на карту.
    					myMap.geoObjects.add(myPolygon_7);
    					createMenu(myPolygon_7, menu);
    					
    					//добавляем события
    					myPolygon_7.events.add('mouseenter', function (e){ fillOpasity_enter(e); });
    					myPolygon_7.events.add('mouseleave', function (e){ fillOpasity_leave(e); });
						

					    function createMenu (item, menu) {
					        // Пункт меню.
					        var menuItem = $('<tr class="grey_on_hover"><td>' + item.properties.get("description") + '</td><td class="center">' + item.properties.get("price") + ' руб.</td></tr>');

					        // Добавляем пункт в меню.
					        menuItem
					            .appendTo(menu)
					            // При клике по пункту меню выделяем полигон.
					            //.find("tr.grey_on_hover")
					            .hover(function (){ 
					            	item.options.set('fillOpacity', '0.5'); 
					            	}, function (){ 
					            	item.options.set('fillOpacity', '0.2'); 
					            	});
					    };

					    // Добавляем меню в тэг BODY.
    					menu.appendTo($("div#delivery_map"));
		
		};
		
		ymaps.ready(init_delivery_map);
	};
});
