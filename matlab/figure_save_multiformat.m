function figure_save_multiformat(fig, basename, formats)

%% figure_save_multiformat.m
% save a figure in multiple formats with a single function call.
% Example: 
%    figure_save_multiformat(gcf, 'first_plot', ['fig', 'png', 'pdf'])

figure(fig); % set current figure

for i=1:length(formats)
    format = formats(i);
    if strcmp(format, fig)
        savefig(strcat(basename, '.fig'));
    else
        print(basename, strcat('-', format));
    end
end