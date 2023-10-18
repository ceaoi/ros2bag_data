%% 

bag_name = 'test4';
bag2mat(bag_name)

load(strcat(bag_name,".mat"))
%%
function bag2mat(bag_name)

    folderPath = fullfile(pwd,bag_name); %pwd为获取当前路径，故需注意数据是否在matlab当前工作文件夹
    bag = ros2bagreader(folderPath);
    
    topics = get_topics(folderPath); %获取所有话题
    for i = 1:size(topics,1) %读取所有话题数据
        bagSel = select(bag,"Topic",topics(i));
        eval(strcat(strrep(topics(i),'/',''),"=readMessages(bagSel);"))
        if i==1
            all_data = strcat('"',strrep(topics(i),'/',''),'"');        

            
        else
            all_data = strcat(all_data,',"',strrep(topics(i),'/',''),'"');
        end
    end
    eval(strcat("save(bag_name,",all_data,")")) %保存到mat中
end

function topics = get_topics(folderPath)

    baginfo = ros2("bag","info",folderPath);
    topics = [];
    for i = 1:size(baginfo.Topics,1)
        topics = [topics; string(baginfo.Topics(i).Topic)];
    end

end