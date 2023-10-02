clear
close all
clc

% odd  %% done: 1,3,5,7,9,11,13,15,17,19,21,23,27
for ii = 1:23
    sig_files = {}; apnea_paths = {}; normal_paths = {}; apn_file = {};
    
    sig_files = {'x1.dat','x02.dat','x03.dat','x04.dat','x05.dat','x06.dat','x07.dat','x08.dat','x09.dat','x10.dat','x11.dat','x12.dat','x13.dat','x14.dat','x15.dat','x16.dat','x17.dat','x18.dat','x19.dat','x20.dat','x21.dat','x22.dat','x23.dat','x24.dat','x25.dat','x26.dat','x27.dat','x28.dat','x29.dat','x30.dat','x31.dat','x32.dat','x33.dat','x34.dat','x35.dat'};
    apn_file = {'x1.txt','x02.txt','x03.txt','x04.txt','x05.txt','x06.txt','x07.txt','x08.txt','x09.txt','x10.txt','x11.txt','x12.txt','x13.txt','x14.txt','x15.txt','x16.txt','x17.txt','x18.txt','x19.txt','x20.txt','x21.txt','x22.txt','x23.txt','x24.txt','x25.txt','x26.txt','x27.txt','x28.txt','x29.txt','x30.txt','x31.txt','x32.txt','x33.txt','x34.txt','x35.txt'};
    
%%%%% Read the whole signal %%%%%
signal_file = fopen(sig_files{ii}); %read .dat signal
y = fread(signal_file, 'int16', 'ieee-le');
len = length(y);
fclose(signal_file);

plot(y)

%%%%% Read and save annotations %%%%%
Annotations = {};
text_annot_file = dir(apn_file{ii});
 nfile = length(text_annot_file);
 ctext = cell(nfile, 1);
 cdata = cell(nfile, 1);
 
 for i = 1:length(text_annot_file)
     fid = fopen(text_annot_file.name);
     ctext{i} = textscan(fid,'%s');  
     cdata{i} = textscan(fid, '%s');
     fclose(fid);
 end

 %Save annotations in separate .mat file 
 index=1; limit = numel(ctext{1,1}{1,1});
 while index<=limit
     Annotations{index} = ctext{1,1}{1,1}{index,1};
     index=index+1;
 end

%%%%% splitting, denosing, spectrogram conversion and classification %%%%
        normal_path = 'D:\Paper_1\Experiments\mannual_test_annotations\test\Narae_mannual_test_data\test_scalograms\normal/';
        normal_dir = dir(fullfile(normal_path, '/*.png'));
        normal_count = numel(normal_dir);
        
        apnea_path = 'D:\Paper_1\Experiments\mannual_test_annotations\test\Narae_mannual_test_data\test_scalograms\apnea/';
        apnea_dir = dir(fullfile(apnea_path, '/*.png'));
        apnea_count = numel(apnea_dir);
        %% normal/apnea images per record %%
        normal_images_per_record = 0; apnea_images_per_record =0;
        for jj = 1:limit
            if strcmp(Annotations(jj), 'N')
                normal_images_per_record = normal_images_per_record+1;
            else
                apnea_images_per_record = apnea_images_per_record+1;
            end
        end
%% convert the first segment %%
    normal_index = 1; apnea_index = 1;
    segm(1,:) = y(1:5999);
    den_sig = smoothdata(segm(1,:));
    
%     [wt,f] = cwt(den_sig);
%     t = 1:5999;
%     hp = pcolor(t,f,abs(wt));
%     hp.EdgeColor = 'none';
%     set(gca,'yscale','log');
    
%     if strcmp(Annotations{1}, 'N')
%         fname = sprintf('%d.png', normal_index+normal_count);
%         normal_folder = fullfile(normal_path, fname);
%         saveas(gcf,normal_folder)
%         normal_index = normal_index+1;
%         elseif strcmp(Annotations{1}, 'A')
%             fname = sprintf('%d.png', apnea_index+apnea_count);
%             apnea_folder = fullfile(apnea_path, fname);
%             saveas(gcf,apnea_folder)
%             apnea_index = apnea_index+1;
%     else
%     end

%% convert rest of the record %%
present = 6000; next=present+5999;
for c = 2:limit
    if next<=len
        ii
        c
        split(c,:) = y(present:next);
        den_sig = smoothdata(split(c,:));
        plot(den_sig)
        
    %     [wt,f] = cwt(den_sig);
    %     t = present:next;
    %     hp = pcolor(t,f,abs(wt));
    %     hp.EdgeColor = 'none';
    %     set(gca,'yscale','log');
        
        if strcmp(Annotations{c}, 'N')
%             fname = sprintf('%d.png', normal_index+normal_count);
%             normal_folder = fullfile(normal_path, fname);
%             saveas(gcf,normal_folder)
            plot(den_sig)
            sprintf('Apnea')
%             normal_index = normal_index+1;

            elseif strcmp(Annotations{c}, 'A')
%                 fname = sprintf('%d.png', apnea_index+apnea_count);
%                 apnea_folder = fullfile(apnea_path, fname);
%                 saveas(gcf,apnea_folder)
                plot(den_sig)
                sprintf('Normal')
%                 apnea_index = apnea_index+1;
        end
    end
    input('')
     present=next+1;
     next=next+6000;
end
end