package com.generatorproject.services.report;

import com.generatorproject.dao.report.AssetReportDAO;
import com.generatorproject.model.report.AssetReportFilter;
import com.generatorproject.model.report.AssetReportKpi;
import com.generatorproject.model.report.AssetReportRow;
import com.generatorproject.model.report.OptionItem;

import java.util.List;

public class AssetReportService {
    private final AssetReportDAO dao = new AssetReportDAO();

    public AssetReportKpi kpis(AssetReportFilter f) {
        return dao.loadKpis(f);
    }

    public int countAssets(AssetReportFilter f) {
        return dao.countAssetsForList(f);
    }

    public List<AssetReportRow> findAssets(AssetReportFilter f, int page, int pageSize) {
        return dao.findAssets(f, page, pageSize);
    }

    public List<OptionItem> customers() { return dao.listCustomersForAssetReport(); }
    public List<OptionItem> models() { return dao.listModelsForAssetReport(); }
}