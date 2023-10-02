clc;
clear
close all;

for sub = 1:1
            sig_file = ['a', num2str(sub), '.dat'];
            ann_file = ['a', num2str(sub), '.txt'];
    
            %% reading signal
            signal_file = fopen(sig_file); %read .dat signal
            sig = fread(signal_file, 'int16', 'ieee-le');
            fclose(signal_file);
            len = length(sig);
            den_sig = smoothdata(sig, "movmean", 4); % denoising
    
            %% Read and save annotations %%
             Annotations = {};
            text_annot_file = dir(ann_file);
             nfile = length(text_annot_file);
             ctext = cell(nfile, 1);
             cdata = cell(nfile, 1);
         
             for i = 1:length(text_annot_file)
                 fid = fopen(text_annot_file(i).name);
                 ctext{i} = textscan(fid,'%s',6);  
                 cdata{i} = textscan(fid, '%s');
                 fclose(fid);
             end
            
             %Save annotations in separate .mat file
             B = [ctext{:}];
             Annotate_1 = B{1,1}{3,1};
             Annotations{1} = Annotate_1;
             L = length(cdata{1,1}{1,1}); 
             
             index=3;
             j=2;
             while index<=L
                 
                 Annotations{j} = cdata{1,1}{1,1}{index,1};
                 index=index+6;
                 j=j+1;
             end
                    limit = numel(Annotations);
    
            %% apnea/normal count for indexing %%
%             normal_path1 = 'E:\Paper_1\Experiments\R_detection_technique\testing_scal\attention_signal\ref_experiments\s_transf\normal/';
%             normal_dir1 = dir(fullfile(normal_path1, '/*.png'));
%             normal_count1 = numel(normal_dir1);
%             
%             
%             apnea_path1 = 'E:\Paper_1\Experiments\R_detection_technique\testing_scal\attention_signal\ref_experiments\s_transf\apnea/';
%             apnea_dir1 = dir(fullfile(apnea_path1, '/*.png'));
%             apnea_count1 = numel(apnea_dir1);
            
            
            %% convert the first segment %%
%             normal_index = 1; apnea_index = 1;
%             segm = den_sig(1:5999);
% 
%             
% 
%             %% S-Transform
%                 [st, t1, f1] = st(segm);
%                 hp = pcolor(t1,f1,abs(st));
%                 hp.EdgeColor = 'none';
%                 set(gca,'yscale','log');
%     
%             if strcmp(Annotations{1}, 'N')
%                 fname = sprintf('%d.png', normal_index+normal_count1);
%                 normal_folder1 = fullfile(normal_path1, fname);
%                 saveas(gcf, normal_folder1)
%                 normal_index = normal_index+1;
%                 clear gcf;
%         
%                 elseif strcmp(Annotations{1}, 'A')
%                 fname = sprintf('%d.png', apnea_index+apnea_count1);
%                 apnea_folder1 = fullfile(apnea_path1, fname);
%                 saveas(gcf, apnea_folder1)
%                 apnea_index = apnea_index+1;
%                 clear gcf;
%             else
%             end
%             clear st; clear t1; clear f1;
    
            %% convert rest of the record %% 37774-37932
        present = 138000; next=present+5999;
        for c = 2:limit-1
            if next<=len
            indices = [sub c]
%             subplot(2,1,1)
%             plot(sig(present:next))
% 
            segm = den_sig(present:next);
%             subplot(2,1,2)
%             plot(segm)

            %% S-Transform
            [st, t1, f1] = st(segm);
            hp = pcolor(t1,f1,abs(st));
            hp.EdgeColor = 'none';
            set(gca,'yscale','log');
        
%             if strcmp(Annotations{c}, 'N')
%                     fname = sprintf('%d.png', normal_index+normal_count1);
%                     normal_folder1 = fullfile(normal_path1, fname);
%                     saveas(gcf, normal_folder1)
%                     normal_index = normal_index+1;
%                     clear gca;
%             
%                     elseif strcmp(Annotations{c}, 'A')
%                     fname = sprintf('%d.png', apnea_index+apnea_count1);
%                     apnea_folder1 = fullfile(apnea_path1, fname);
%                     saveas(gcf, apnea_folder1)
%                     apnea_index = apnea_index+1;
%                     clear gca;
%                 else
%              end
%              clear st; clear t1; clear f1;
             present=next+1;
             next=next+6000;
             input('')
        end
        end
end