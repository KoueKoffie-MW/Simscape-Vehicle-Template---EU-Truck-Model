% This example operates on an Excel file called test.xls in the
% current directory. The test.xls file has 3 worksheets by default. This file can be 
% created by creating a new Excel file via Microsoft Excel and saving it as test.xls.
% Get information returned by XLSINFO on the workbook
XL_file = 'sm_car_data_Aero_Coefficients.xlsx';
[type, sheet_names] = xlsfinfo(XL_file);

% First open Excel as a COM Automation server
Excel = actxserver('Excel.Application'); 
% Make the application invisible
set(Excel, 'Visible', 0);
% Make excel not display alerts
set(Excel,'DisplayAlerts',0);
% Get a handle to Excel's Workbooks
Workbooks = Excel.Workbooks; 
% Open an Excel Workbook and activate it
Workbook=Workbooks.Open(XL_file);
% Get the sheets in the active Workbook
Sheets = Excel.ActiveWorkBook.Sheets;


current_sheet = get(Sheets, 'Item', (i-index_adjust));
invoke(current_sheet, 'Delete')
out_string = sprintf('Worksheet called %s deleted',sheet_names{i});

% Cycle through the sheets and delete them based on user input
for i = 1:max(size(sheet_names))
      inp_prompt = sprintf('Do you want to delete the Worksheet called %s [y/n]?',sheet_names{i});
      user_inp = lower(input(inp_prompt,'s'));
      switch user_inp
          case{'y'}
              current_sheet = get(Sheets, 'Item', (i-index_adjust));
              invoke(current_sheet, 'Delete')
              out_string = sprintf('Worksheet called %s deleted',sheet_names{i});
              index_adjust = index_adjust +1;
          otherwise
              out_string = sprintf('Worksheet called %s ***NOT*** deleted',sheet_names{i});
      end
      disp(out_string);
      disp(' ');
end
% Now save the workbook
Workbook.Save;
% Close the workbook
Workbooks.Close;
% Quit Excel
invoke(Excel, 'Quit');
% Delete the handle to the ActiveX Object
delete(Excel);