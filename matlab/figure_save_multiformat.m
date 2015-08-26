function figure_save_multiformat(fig, formats)

%% save figures
basename = 'plot';
for i=1:length(formats)
    format = formats(i);
    if strcmp(format, fig)
        savefig(strcat(basename, '.fig'));
    else
        print(basename, strcat('-', format));
    end
end