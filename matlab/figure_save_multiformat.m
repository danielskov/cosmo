function figure_save_multiformat(fig, basename, formats)

%% figure_save_multiformat.m
% save a figure in multiple formats with a single function call.
% Example: 
%    figure_save_multiformat(gcf, 'first_plot', ['fig', 'png', 'pdf'])

for i=1:length(formats)
    format = formats(i);
    if strcmp(format, 'fig')
        %savefig(fig, strcat(basename, '.fig'), '-v7.3');
        savefig(fig, strcat(basename, '.fig'), 'compact');
    else
        print(fig, basename, strcat('-d', cell2mat(format)));
    end
end