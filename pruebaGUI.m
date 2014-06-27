function varargout = pruebaGUI(varargin)
% PRUEBAGUI MATLAB code for pruebaGUI.fig
%      PRUEBAGUI, by itself, creates a new PRUEBAGUI or raises the existing
%      singleton*.
%
%      H = PRUEBAGUI returns the handle to a new PRUEBAGUI or the handle to
%      the existing singleton*.
%
%      PRUEBAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRUEBAGUI.M with the given input arguments.
%
%      PRUEBAGUI('Property','Value',...) creates a new PRUEBAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pruebaGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pruebaGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pruebaGUI

% Last Modified by GUIDE v2.5 27-Jun-2014 10:20:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pruebaGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @pruebaGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before pruebaGUI is made visible.
function pruebaGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pruebaGUI (see VARARGIN)

% Choose default command line output for pruebaGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pruebaGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pruebaGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in botonCargarDatosMaquina1.
function botonCargarDatosMaquina1_Callback(hObject, eventdata, handles)
    cargarDatosTabla(handles.listaEstadosMaquina1Seleccionados, handles.tablaMaquina1);

% hObject    handle to botonCargarDatosMaquina1 (see GCBO)
% eventdata  reserved - to be defined in a http://www.marca.com/future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in botonCargarDatosMaquina2.
function botonCargarDatosMaquina2_Callback(hObject, eventdata, handles)
    cargarDatosTabla(handles.listaEstadosMaquina2, handles.tablaMaquina2);
    lista = get(handles.listaEstadosMaquina1Seleccionados, 'String');
    [filas, columnas] = size(lista)
    vector= cell(1, filas);
    vector(1:filas) = {'Vacio'};
    set(handles.listaEstadosMaquina2Seleccionados, 'String', vector);
% hObject    handle to botonCargarDatosMaquina2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function [] = agregarElementoLista(listaA, listaB)
  estadosA = get(listaA, 'String');
  valorSeleccionado = get(listaA, 'Value');
  estadosB = get(listaB, 'String');
  tamanio = size(estadosB);
  hayVacio = 0;
  
  for i = 1:tamanio
      if strcmp(estadosB(i), 'Vacio')
          hayVacio = 1; 
          estadosB(i) = estadosA(valorSeleccionado);
          set(listaB, 'String', estadosB);
          return
      end
  end
  
  if(hayVacio == 0)
      msgbox('No hay casillas vacias. Primero elimine un elemento de la lista');
  end

function [] = borrarDatos(tabla)
    set(tabla, 'Data', cell(4, 2));
    set(tabla, 'RowName', 1:4);
    set(tabla, 'ColumnName', 1:2);
    set(tabla, 'ColumnWidth', {'auto'});


function cargarDatosTabla(lista, tabla)
    [fileName, path]= uigetfile({'*.xls;*.xlsx'},'Abrir archivos Excel');
    if isequal(fileName, 0) 
        return 
    else 
        ruta = strcat(path, fileName);
        [~, ~, numeroTexto] = xlsread(ruta);
        [nuevaTabla] = determinarNuevaTabla(numeroTexto); 
        [filas, columnas] = size(nuevaTabla);
        set(tabla, 'Data', nuevaTabla(2:filas, 2:columnas));
        set(tabla, 'RowName', nuevaTabla(2:filas, 1));
        set(tabla, 'ColumnName', nuevaTabla(1, 2:columnas));
        set(tabla, 'ColumnWidth', {50});
        set(lista, 'String', nuevaTabla(2:filas, 1));
    end

function [filaInicial, columnaInicial] = determinarIndicesNuevaTabla(tabla, filas, columnas)
    for i = 1:filas
        for j = 1:columnas
            if((strcmp(tabla(i,j), 'E') || strcmp(tabla(i,j), 'Estado')))
                filaInicial = i;
                columnaInicial = j;
                return;
            end
        end
    end
    
function [nuevaTabla] = determinarNuevaTabla(numeroTexto)
    [filas, columnas] = size(numeroTexto);
    [filaInicial, columnaInicial] = determinarIndicesNuevaTabla(numeroTexto, filas, columnas);
    nuevaTabla = numeroTexto(filaInicial:filas, columnaInicial:columnas);
    
function [] = cargarTablaHomomorfismo(handles)
    
    tabla = handles.tablaMaquina1;
    phi = get(handles.listaEstadosMaquina2Seleccionados, 'String');
    
    estados = get(tabla, 'RowName');
    entradas = get(tabla, 'ColumnName');
    datos = get(tabla, 'Data');
    
    numeroEntradas = size(entradas);
    numeroEstados = size(estados);
    
    salidas = datos(:,numeroEntradas);
    entradas = entradas(1:numeroEntradas-1);
    numeroEntradas = size(entradas);
    celdas = cell(numeroEstados(1)*(numeroEntradas(1)-1), 8);
    k = 1;
    
    for i = 1:numeroEstados
        for j = 1:numeroEntradas
            celdas(k, 1) = estados(i);
            celdas(k, 2) = entradas(j);
            celdas(k, 3) = phi(i);
            celdas(k, 4) = funcionTransferenciaEstado(estados(i), entradas(j), tabla);
            celdas(k, 5) = funcionPhi(celdas(k, 4), handles);
            celdas(k, 6) = funcionTransferenciaEstado(phi(i), entradas(j), tabla);
            celdas(k, 7) = salidas(i);
            celdas(k, 8) = funcionSalida(phi(i), handles.tablaMaquina2);
            k = k + 1;
        end
    end
    set(handles.tablaHomomorfismo, 'Data', celdas);
    
function [estado] = funcionTransferenciaEstado(estado, entrada, tablaReferencia)
    estados = get(tablaReferencia, 'RowName');
    entradas = get(tablaReferencia, 'ColumnName');
    
    for i = 1:size(estados)
        if(strcmp(estados(i), estado))
            indiceEstado = i;
            break;
        end
    end
   
    for j = 1:size(entradas)
        if(strcmp(entradas(j), entrada))
            indiceEntrada = j;
            break;
        end
    end
    
    datos = get(tablaReferencia, 'Data');
    estado = datos(indiceEstado, indiceEntrada);
    
function [estado] = funcionPhi(estado, handles)
    phi = [get(handles.listaEstadosMaquina1Seleccionados, 'String'), get(handles.listaEstadosMaquina2Seleccionados, 'String')]
    
    [filas, columnas] = size(phi);
    for i = 1:filas
        if(strcmp(phi(i, 1), estado))
            estado = phi(i, 2);
            return;
        end
    end
    
function [] =  quitarElementoLista(lista)
    estados = get(lista,'String')
    valorSeleccionado = get(lista, 'Value')
    if(strcmp(estados(valorSeleccionado), 'Vacio'))
        msgbox('Valor seleccionado ya vacio');
    else
        estados(valorSeleccionado) = {'Vacio'}
        set(lista,'String', estados);
    end

  
function [salida] = funcionSalida(estado, maquinaTabla)
    estados = get(maquinaTabla, 'RowName');
    entradas = get(maquinaTabla, 'ColumnName');
    datos = get(maquinaTabla, 'Data');
        
    [filas, tamanioColumnas] = size(entradas);
    tamanioFilas = size(estados);
    
    for i = 1:tamanioFilas
        if strcmp(estado, estados(i))
            break;
        end
    end
    salida = datos(i,filas);
    
function [sonIguales] = sonIgualesTransicionEstados(tabla)
    datos = get(tabla, 'Data');
    [numeroFilas, numeroColumnas] = size(datos);
    for i = 1:numeroFilas
        if(cell2mat(datos(i, 5)) ~= cell2mat(datos(i, 6)))
            sonIguales = 0;
            return;
        end
    end
    sonIguales = 1;
    disp(sonIguales);
    
function [sonIguales] = sonIgualesSalidas(tabla)
    datos = get(tabla, 'Data');
    [numeroFilas, numeroColumnas] = size(datos);
    for i = 1:numeroFilas
        if(cell2mat(datos(i, 7)) ~= cell2mat(datos(i, 8)))
            sonIguales = 0;
            return;
        end
    end
    sonIguales = 1;
    disp(sonIguales);

function [esHomomorfismo] = verificarHomomorfismo(tabla, handles)
    if(sonIgualesTransicionEstados(tabla) == 1)
        if(sonIgualesSalidas(tabla) == 1)
            esHomomorfismo = 1;
            return;
        end
    end
    esHomomorfismo = 0;
    
function [esMonomorfismo] = verificarMonomorfismo(listaEstadosE, handles)
    [numeroFilas, numeroColumnas] = size(listaEstadosE);
    
    for i = 1:numeroFilas-1
        for j = i+1:numeroFilas
            if(strcmp(funcionPhi(listaEstadosE(i), handles), funcionPhi(listaEstadosE(j), handles)))
                esMonomorfismo = 0
                return;
            end
        end
    end
    esMonomorfismo = 1;
    
function [esEpimorfismo] = verificarEpimorfismo(listaEstadosESeleccionados, listaEstadosE)

    [numeroEstadosESeleccionados, numeroColumnas] = size(listaEstadosESeleccionados);
    [numeroEstadosE, numeroColumnas] = size(listaEstadosESeleccionados);
    esta = 0;
    
    disp('lista1')
    numeroEstadosE
    numeroEstadosESeleccionados
    
    for i = 1:numeroEstadosE
        esta = 0;
        for j = 1:numeroEstadosESeleccionados
            if(strcmp(listaEstadosE(i), listaEstadosESeleccionados(j)))
                esta = 1;
            end
        end
        
        if(esta == 0)
            esEpimorfismo = 0;
            return;
            
        end
    end
    
    esEpimorfismo = 1;
    
% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in botonBorrarDatosMaquina1.
function botonBorrarDatosMaquina1_Callback(hObject, eventdata, handles)
    borrarDatos(handles.tablaMaquina1);
% hObject    handle to botonBorrarDatosMaquina1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in botonBorrarDatosMaquina2.
function botonBorrarDatosMaquina2_Callback(hObject, eventdata, handles)
    borrarDatos(handles.tablaMaquina2);
% hObject    handle to botonBorrarDatosMaquina2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in botonVerificarDatos.
function botonVerificarDatos_Callback(hObject, eventdata, handles)
% hObject    handle to botonVerificarDatos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listaEstadosMaquina1.
function listaEstadosMaquina1_Callback(hObject, eventdata, handles)
% hObject    handle to listaEstadosMaquina1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listaEstadosMaquina1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listaEstadosMaquina1


% --- Executes during object creation, after setting all properties.
function listaEstadosMaquina1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listaEstadosMaquina1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listaEstadosMaquina2.
function listaEstadosMaquina2_Callback(hObject, eventdata, handles)
% hObject    handle to listaEstadosMaquina2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listaEstadosMaquina2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listaEstadosMaquina2


% --- Executes during object creation, after setting all properties.
function listaEstadosMaquina2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listaEstadosMaquina2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in agregarEstadoE.
function agregarEstadoE_Callback(hObject, eventdata, handles)
    agregarElementoLista(handles.listaEstadosMaquina1, handles.listaEstadosMaquina1Seleccionados);
    %estadosE = get(handles.listaEstadosMaquina1, 'String')
    %valorSeleccionado = get(handles.listaEstadosMaquina1, 'Value')
    %set(handles.listaEstadosMaquina1Seleccionados, 'String', [get(handles.listaEstadosMaquina1Seleccionados, 'String'); estadosE(valorSeleccionado)]);
% hObject    handle to agregarEstadoE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in quitarEstadoE.
function quitarEstadoE_Callback(hObject, eventdata, handles)
    quitarElementoLista(handles.listaEstadosMaquina1Seleccionados);
% hObject    handle to quitarEstadoE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in botonQuitarElemento.
function botonQuitarElemento_Callback(hObject, eventdata, handles)
    quitarElementoLista(handles.listaEstadosMaquina2Seleccionados);
% hObject    handle to botonQuitarElemento (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in botonAgregarElemento.
function botonAgregarElemento_Callback(hObject, eventdata, handles)
    agregarElementoLista(handles.listaEstadosMaquina2, handles.listaEstadosMaquina2Seleccionados);
% hObject    handle to botonAgregarElemento (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listaEstadosMaquina2Seleccionados.
function listaEstadosMaquina2Seleccionados_Callback(hObject, eventdata, handles)
% hObject    handle to listaEstadosMaquina2Seleccionados (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listaEstadosMaquina2Seleccionados contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listaEstadosMaquina2Seleccionados


% --- Executes during object creation, after setting all properties.
function listaEstadosMaquina2Seleccionados_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listaEstadosMaquina2Seleccionados (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listaEstadosMaquina1Seleccionados.
function listaEstadosMaquina1Seleccionados_Callback(hObject, eventdata, handles)
% hObject    handle to listaEstadosMaquina1Seleccionados (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listaEstadosMaquina1Seleccionados contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listaEstadosMaquina1Seleccionados


% --- Executes during object creation, after setting all properties.
function listaEstadosMaquina1Seleccionados_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listaEstadosMaquina1Seleccionados (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in botonVerificarPropiedades.
function botonVerificarPropiedades_Callback(hObject, eventdata, handles)
    cargarTablaHomomorfismo(handles);
    if(verificarHomomorfismo(handles.tablaHomomorfismo, handles))
        set(handles.etiquetaHomomorfismo, 'BackgroundColor', 'Green');
        set(handles.etiquetaHomomorfismo, 'String', 'SI');
        if(verificarMonomorfismo(get(handles.listaEstadosMaquina1Seleccionados, 'String'), handles))
            set(handles.etiquetaMonomorfismo, 'BackgroundColor', 'Green');
            set(handles.etiquetaMonomorfismo, 'String', 'SI');
            disp('asdada')
        else 
            set(handles.etiquetaMonomorfismo, 'BackgroundColor', 'Red');
            set(handles.etiquetaMonomorfismo, 'String', 'NO');    
        end
        
        if(verificarEpimorfismo(get(handles.listaEstadosMaquina2Seleccionados, 'String'), get(handles.listaEstadosMaquina2, 'String')))
            set(handles.etiquetaEpimorfismo, 'BackgroundColor', 'Green');
            set(handles.etiquetaEpimorfismo, 'String', 'SI');
        else 
            set(handles.etiquetaEpimorfismo, 'BackgroundColor', 'Red');
            set(handles.etiquetaEpimorfismo, 'String', 'NO');    
        end
        
        if(strcmp(get(handles.etiquetaMonomorfismo, 'String'), 'SI') && strcmp(get(handles.etiquetaEpimorfismo, 'String'), 'SI'))
            set(handles.etiquetaIsomorfismo, 'BackgroundColor', 'Green');
            set(handles.etiquetaIsomorfismo, 'String', 'SI');
        else
            set(handles.etiquetaIsomorfismo, 'BackgroundColor', 'Red');
            set(handles.etiquetaIsomorfismo, 'String', 'NO');
        end
        
    else
       set(handles.etiquetaHomomorfismo, 'BackgroundColor', 'Red');
       set(handles.etiquetaHomomorfismo, 'String', 'NO'); 
    end
        
% hObject    handle to botonVerificarPropiedades (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
